# frozen_string_literal: true

module JsonModel
  module Properties
    extend(ActiveSupport::Concern)

    included do
      extend(ActiveSupport::DescendantsTracker)
      include(ActiveModel::Validations)

      class_attribute(:attributes, instance_writer: false, default: {})
      class_attribute(:properties, instance_writer: false, default: {})
    end

    class_methods do
      # @param [Symbol] name
      # @param [Object] type
      # @param [Hash] options
      def property(name, type:, **options)
        property_options = options.slice(:default, :optional)
        resolved_type = TypeSpec.resolve(type, **options.except(:default, :optional))
        add_property(name, type: resolved_type, **property_options)
        descendants.each { |subclass| subclass.add_property(name, type: resolved_type, **property_options) }
      end

      protected

      # @param [Symbol] name
      # @param [TypeSpec] type
      # @param [Hash] options
      def add_property(name, type:, **options)
        property = Property.new(name, type: type, **options)
        properties[name] = property
        define_accessors(property)
        define_validations(property)
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

      # @param [Property] property
      def define_validations(property)
        property.register_validations(self)
      end
    end
  end
end
