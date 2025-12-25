# frozen_string_literal: true

module JsonModel
  module Schema
    extend(ActiveSupport::Concern)
    include(Properties)

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
  end
end
