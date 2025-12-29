# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Const < TypeSpec
      # @param [String] value
      def initialize(value)
        super()
        @value = value

        if value.blank?
          raise(ArgumentError, 'Const type spec requires a non-empty value')
        end
      end

      # @param [Hash] _options
      # @return [Hash]
      def as_schema(**_options)
        {
          const: @value,
        }.compact
      end

      # @param [Symbol] name
      # @param [ActiveModel::Validations] klass
      def register_validations(name, klass)
        super

        klass.validates(name, inclusion: { in: @value }, allow_nil: true)
      end
    end
  end
end
