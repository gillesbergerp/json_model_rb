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

    class_methods do
      # @return [Hash]
      def as_schema
        meta_attributes
          .merge(
            properties: properties_as_schema,
            required: required_properties_as_schema,
          )
          .compact
      end

      private

      # @return [Hash, nil]
      def properties_as_schema
        if properties.any?
          properties
            .sort_by { |key, _property| key }
            .map { |_key, property| property.as_schema }
            .inject({}, &:merge)
        end
      end

      # @return [Array, nil]
      def required_properties_as_schema
        if properties.any?
          properties
            .values
            .select(&:required?)
            .map(&:alias)
            .sort
        end
      end
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
  end
end
