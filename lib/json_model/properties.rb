# frozen_string_literal: true

module JsonModel
  module Properties
    extend(ActiveSupport::Concern)

    included do
      extend(ActiveSupport::DescendantsTracker)

      class_attribute(:properties, instance_writer: false, default: {})
    end

    class_methods do
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
        properties[name] = Property.new(name, type: type, **options)
      end
    end
  end
end
