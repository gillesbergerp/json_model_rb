# frozen_string_literal: true

module JsonModel
  module Schema
    extend(ActiveSupport::Concern)
    include(Properties)
    include(SchemaMeta)

    # @param [Hash, nil] attributes
    def initialize(attributes = nil)
      return unless attributes

      assign_attributes(attributes)
    end

    private

    # @param [Hash, nil] attributes
    def assign_attributes(attributes)
      attributes.each { |name, value| assign_attribute(name, value) }
    end

    # @param [Symbol] name
    # @param [Object] value
    def assign_attribute(name, value)
      if !respond_to?("#{name}=")
        raise(Errors::UnknownAttributeError.new(self.class, name))
      end

      send("#{name}=", value)
    end

    class_methods do
      # @param [Symbol] ref_mode
      # @param [Hash] _options
      # @return [Hash]
      def as_schema(ref_mode: RefMode::INLINE, **_options)
        case ref_mode
        when RefMode::INLINE
          meta_attributes
            .merge(
              properties: properties_as_schema,
              required: required_properties_as_schema,
              '$defs': defs_as_schema,
            )
            .merge(type: 'object')
            .compact
        when RefMode::LOCAL
          { '$ref': "#/$defs/#{name}" }
        when RefMode::EXTERNAL
          { '$ref': schema_id }
        else
          raise(Errors::InvalidRefModeError, ref_mode)
        end
      end

      # @return [Hash, nil]
      def properties_as_schema
        if local_properties.any?
          local_properties
            .sort_by { |key, _property| key }
            .map { |_key, property| property.as_schema }
            .inject({}, &:merge)
        end
      end

      # @return [Array, nil]
      def required_properties_as_schema
        if local_properties.any?
          local_properties
            .values
            .select(&:required?)
            .map(&:alias)
            .sort
        end
      end

      def defs_as_schema
        referenced_schemas = local_properties
                                    .values
                                    .flat_map(&:referenced_schemas)
                                    .uniq

        if referenced_schemas.any?
          referenced_schemas.to_h { |type| [type.name.to_sym, type.as_schema] }
        end
      end

      # @return [Array<Class>]
      def parent_schemas
        @parent_schemas ||= ancestors.select { |klass| klass != self && klass < Schema }
      end

      # @return [Hash]
      def local_properties
        if !defined?(@local_properties)
          ancestor_properties = parent_schemas.flat_map { |property| property.properties.values }
          @local_properties = properties.select do |_key, property|
            ancestor_properties.none? { |ancestor_property| ancestor_property == property }
          end
        end

        @local_properties
      end
    end
  end
end
