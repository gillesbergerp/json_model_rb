# frozen_string_literal: true

module JsonModel
  module Types
    class << self
      # @param [Object] value
      # @return [Const]
      def const(value)
        Const.new(value)
      end
    end

    class Const
      include(Type)
      include(Builder)

      attr_reader(:value)

      # @param [Object] value
      def initialize(value)
        @value = value

        if value.blank?
          raise(ArgumentError, 'Const type spec requires a non-empty value')
        end
      end

      # @param [Hash] _options
      # @return [Hash]
      def as_schema(**_options)
        {
          const: value,
        }.compact
      end

      # @param [Symbol] name
      # @param [ActiveModel::Validations] klass
      def register_validations(name, klass)
        super

        klass.validates(name, inclusion: { in: [value] }, allow_nil: true)
      end
    end
  end
end
