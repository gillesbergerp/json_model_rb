# frozen_string_literal: true

require_relative('numeric')

module JsonModel
  module Types
    class << self
      # @return [Types::Primitive::Integer]
      def integer
        Primitive::Integer.new
      end
    end

    class Primitive
      class Integer < Numeric
        def initialize
          super(types: [Integer], schema_type: 'integer')
        end

        # @param [Symbol] name
        # @param [ActiveModel::Validations] klass
        def register_validations(name, klass)
          super
          klass.validates(name, numericality: { only_integer: true }, allow_nil: true)
        end
      end
    end
  end
end
