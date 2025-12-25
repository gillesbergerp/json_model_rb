# frozen_string_literal: true

module JsonModel
  module Errors
    class UnknownAttributeError < Error
      # @param [Class] klass
      # @param [Symbol] name
      def initialize(klass, name)
        super("Unknown attribute '#{name}' for '#{klass}'.")
      end
    end
  end
end
