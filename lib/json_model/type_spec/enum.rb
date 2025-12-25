# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Enum < TypeSpec
      # @param [Array<Object>] enum
      def initialize(enum:)
        @enum = enum

        if @enum.blank?
          raise(ArgumentError, 'Enum type spec requires a non-empty enum array')
        end
      end

      # @return [Hash]
      def as_schema
        {
          enum: @enum,
        }.compact
      end

      # @param [Symbol] name
      # @param [ActiveModel::Validations] klass
      def register_validations(name, klass)
        super

        klass.validates(name, inclusion: { in: @enum })
      end
    end
  end
end
