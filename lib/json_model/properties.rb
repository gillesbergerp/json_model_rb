# frozen_string_literal: true

module JsonModel
  module Properties
    extend(ActiveSupport::Concern)

    included do
      extend(ActiveSupport::DescendantsTracker)
      include(ActiveModel::Validations)
    end

    # @return [Hash]
    def attributes
      @attributes ||= {}
    end

    class_methods do
      # @return [Hash]
      def properties
        @properties ||= {}
      end

      # @return [Hash]
      def aliased_properties
        @aliased_properties ||= {}
      end

      # @param [Symbol] name
      # @return [Symbol, nil]
      def invert_alias(name)
        aliased_properties[name]&.name || superclass&.invert_alias(name)
      rescue NoMethodError
      end

      # @param [Symbol] name
      # @param [Object, Class] type
      # @param [Hash] options
      def property(name, type:, **options)
        property_options = options.slice(:default, :optional, :ref_mode, :as)
        resolved_type = TypeSpec.resolve(type, **options.except(:default, :optional, :ref_mode, :as))
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
        aliased_properties[property.alias] = property
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
        define_method("#{property.name}=") { |value| attributes[property.name] = property.type.cast(value) }
      end

      # @param [Property] property
      def define_validations(property)
        property.register_validations(self)
      end
    end
  end
end
