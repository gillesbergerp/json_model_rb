# frozen_string_literal: true

module JsonModel
  module Properties
    extend(ActiveSupport::Concern)

    included do
      extend(ActiveSupport::DescendantsTracker)

      class_attribute(:attributes, instance_writer: false, default: {})
      class_attribute(:properties, instance_writer: false, default: {})
    end

    class_methods do
      # @return [Hash]
      def as_schema
        {
          properties: properties
            .sort_by { |key, _property| key }
            .map { |_key, property| property.as_schema }
            .inject({}, &:merge),
        }
      end

      # @param [Symbol] name
      # @param [Object] type
      # @param [Hash] options
      def property(name, type:, **options)
        resolved_type = TypeSpec.resolve(type)
        add_property(name, type: resolved_type, **options)
        descendants.each { |subclass| subclass.add_property(name, type: resolved_type, **options) }
      end

      protected

      # @param [Symbol] name
      # @param [Object] type
      # @param [Hash] options
      def add_property(name, type:, **options)
        property = Property.new(name, type: type, **options)
        properties[name] = property
        define_accessors(property)
      end

      # @param [Property] property
      def define_accessors(property)
        define_getter(property)
        define_setter(property)
      end

      # @param [Property] property
      def define_getter(property)
        define_method(property.name) do
          if attributes.key?(property.name)
            attributes[property.name]
          else
            property.default
          end
        end
      end

      # @param [Property] property
      def define_setter(property)
        define_method("#{property.name}=") { |value| attributes[property.name] = value }
      end
    end
  end
end
