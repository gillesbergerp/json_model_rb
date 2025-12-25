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
      # @param [Hash] options
      def property(name, **options)
        add_property(name, **options)
        descendants.each { |subclass| subclass.add_property(name, **options) }
      end

      protected

      # @param [Symbol] name
      # @param [Hash] options
      def add_property(name, **options)
        properties[name] = Property.new(name, **options)
      end
    end
  end
end
