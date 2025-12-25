# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Primitive
      class Integer < Numeric
        def initialize
          super('integer')
        end

        # @param [Symbol] name
        # @param [ActiveModel::Validations] klass
        def register_validations(name, klass)
          super
          klass.validates(name, numericality: { only_integer: true })
        end
      end
    end
  end
end
