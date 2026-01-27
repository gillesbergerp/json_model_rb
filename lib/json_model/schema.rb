# frozen_string_literal: true

require_relative('builder')
require_relative('schema_meta')

module JsonModel
  module Schema
    extend(ActiveSupport::Concern)
    include(SchemaMeta)

    class_methods do
      # @param [Hash] attributes
      # @param [FalseClass, TrueClass] safe
      # @param [Proc] block
      # @return [::Object, nil]
      def new(attributes = default_attributes, safe = false, &block)
        super(
          attributes.transform_keys { |key| invert_alias(key) },
          safe,
          &block
        )
      end

      # @param [Symbol] key
      # @return [Symbol]
      def invert_alias(key)
        builder = builders.find { |b| b.alias.to_s == key.to_s }
        builder&.type&.name || key
      end

      # @return [Hash]
      def as_schema
        {
          properties: properties_as_schema,
          required: required_properties_as_schema,
          '$defs': defs_as_schema,
        }
          .merge(type: 'object')
          .merge(meta_attributes)
          .compact
      end

      # @return [Hash, nil]
      def properties_as_schema
        if local_builders.any?
          local_builders
            .sort_by(&:alias)
            .map(&:as_schema)
            .inject({}, &:merge)
        end
      end

      # @return [Array, nil]
      def required_properties_as_schema
        if local_builders.any?
          local_builders
            .reject(&:optional?)
            .map(&:alias)
            .sort
        end
      end

      # @return [Hash, nil]
      def defs_as_schema
        referenced_schemas = local_builders
                               .flat_map(&:referenced_schemas)
                               .uniq

        if referenced_schemas.any?
          referenced_schemas.to_h { |type| [type.name.to_sym, type.as_schema] }
        end
      end

      # @return [Array<Builder>]
      def local_builders
        @local_builders ||= @schema
                              .type
                              .reject { |type| parent_keys.include?(type) }
                              .map { |type| Builder.for(type) }
      end

      # @return [Array<Builder>]
      def builders
        @builders ||= local_builders + @schema
                                         .type
                                         .select { |type| parent_keys.include?(type) }
                                         .map { |type| Builder.for(type) }
      end

      # @return [Array<Class>]
      def parent_keys
        @parent_keys ||= ancestors
                           .select { |klass| referenceable_parent?(klass) }
                           .flat_map { |klass| klass.schema.type.keys }
      end

      # @param [Class] klass
      # @return [FalseClass, TrueClass]
      def referenceable_parent?(klass)
        klass < JsonModel::Schema && klass != self && schema_id != klass.schema_id
      end
    end
  end
end
