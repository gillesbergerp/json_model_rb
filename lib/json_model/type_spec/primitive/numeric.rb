# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Primitive
      class Numeric < Primitive
        # @param [String] type
        # @param [Integer, nil] multiple_of
        # @param [Integer, nil] minimum
        # @param [Integer, nil] maximum
        # @param [Integer, nil] exclusive_minimum
        # @param [Integer, nil] exclusive_maximum
        def initialize(
          type,
          multiple_of: nil,
          minimum: nil,
          maximum: nil,
          exclusive_minimum: nil,
          exclusive_maximum: nil
        )
          super(type)
          @multiple_of = multiple_of
          @minimum = minimum
          @maximum = maximum
          @exclusive_minimum = exclusive_minimum
          @exclusive_maximum = exclusive_maximum
        end

        # @return [Hash]
        def as_schema
          super
            .merge(
              {
                multipleOf: @multiple_of,
                minimum: @minimum,
                maximum: @maximum,
                exclusiveMinimum: @exclusive_minimum,
                exclusiveMaximum: @exclusive_maximum,
              }.compact,
            )
        end

        # @param [Symbol] name
        # @param [ActiveModel::Validations] klass
        def register_validations(name, klass)
          super
          register_multiple_of_validation(name, klass, @multiple_of)
          if @minimum || @maximum || @exclusive_minimum || @exclusive_maximum
            klass.validates_numericality_of(
              name,
              **{
                greater_than: @exclusive_minimum,
                less_than: @exclusive_maximum,
                greater_than_or_equal_to: @minimum,
                less_than_or_equal_to: @maximum,
              }.compact,
            )
          end
        end

        private

        # @param [Symbol] name
        # @param [ActiveModel::Validations] klass
        # @param [Integer, nil] multiple_of
        def register_multiple_of_validation(name, klass, multiple_of)
          if multiple_of.nil?
            return
          end

          klass.validate do |record|
            value = record.send(name)
            if value.present? && value % multiple_of != 0
              record.errors.add(name, :multiple_of, message: "must be a multiple of #{multiple_of}")
            end
          end
        end
      end
    end
  end
end
