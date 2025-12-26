# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Enum < TypeSpec
      # @param [Array<Object, nil>] values
      def initialize(*values)
        super()
        @values = values

        if @values.blank?
          raise(ArgumentError, 'Enum type spec requires a non-empty enum array')
        end
      end

      # @param [Hash] _options
      # @return [Hash]
      def as_schema(**_options)
        {
          enum: @values,
        }.compact
      end

      # @param [Symbol] name
      # @param [ActiveModel::Validations] klass
      def register_validations(name, klass)
        super

        klass.validates(name, inclusion: { in: @values })
      end
    end
  end
end
