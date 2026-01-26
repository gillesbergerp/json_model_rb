# frozen_string_literal: true

module JsonModel
  module Types
    module Builder
      module Maximum
        extend(ActiveSupport::Concern)
        include(Builder)

        included do
          register_constraint(:maximum, Constraint)
        end

        # @param [Numeric] value
        # @return [Builder]
        def maximum(value)
          register(Constraint.new(value))
        end

        class Constraint
          # @param [Numeric] maximum
          def initialize(maximum)
            @maximum = maximum
          end

          # @return [Hash]
          def as_schema
            { maximum: @maximum }
          end

          # @param [Symbol] name
          # @param [ActiveModel::Validations] klass
          def register_validations(name, klass)
            klass.validates_numericality_of(
              name,
              less_than_or_equal_to: @maximum,
              allow_nil: true,
            )
          end
        end
      end
    end
  end
end
