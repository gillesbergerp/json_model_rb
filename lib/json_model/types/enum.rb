# frozen_string_literal: true

module JsonModel
  module Types
    class << self
      # @param [Array<Object, nil>] values
      # @return [Enum]
      def enum(*values)
        Enum.new(*values)
      end
    end

    class Enum
      include(Type)
      include(Builder)

      attr_reader(:values)

      # @param [Array<Object, nil>] values
      def initialize(*values)
        @values = values

        if @values.blank?
          raise(ArgumentError, 'Enum type spec requires a non-empty enum array')
        end
      end

      # @param [Hash] _options
      # @return [Hash]
      def as_schema(**_options)
        {
          enum: values,
        }.compact
      end

      # @param [Symbol] name
      # @param [ActiveModel::Validations] klass
      def register_validations(name, klass)
        super

        klass.validates(name, inclusion: { in: values }, allow_nil: true)
      end
    end
  end
end
