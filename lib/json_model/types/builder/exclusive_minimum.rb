# frozen_string_literal: true

module JsonModel
  module Types
    module Builder
      module ExclusiveMinimum
        extend(ActiveSupport::Concern)
        include(Builder)

        included do
          register_constraint(:exclusive_minimum, Constraint)
        end

        # @param [Numeric] value
        # @return [Builder]
        def exclusive_minimum(value)
          register(Constraint.new(value))
        end

        class Constraint
          # @param [Numeric] exclusive_minimum
          def initialize(exclusive_minimum)
            @exclusive_minimum = exclusive_minimum
          end

          # @param [Hash] _options
          # @return [Hash]
          def as_schema(**_options)
            { exclusiveMinimum: @exclusive_minimum }
          end

          # @param [Symbol] name
          # @param [ActiveModel::Validations] klass
          def register_validations(name, klass)
            klass.validates_numericality_of(
              name,
              greater_than: @exclusive_minimum,
              allow_nil: true,
            )
          end
        end
      end
    end
  end
end
