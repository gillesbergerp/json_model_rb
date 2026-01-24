# frozen_string_literal: true

module JsonModel
  module Types
    module Builder
      module ExclusiveMaximum
        extend(ActiveSupport::Concern)
        include(Builder)

        included do
          register_constraint(:exclusive_maximum, Constraint)
        end

        # @param [Numeric] value
        # @return [Builder]
        def exclusive_maximum(value)
          register(Constraint.new(value))
        end

        class Constraint
          include(Types::Constraint)

          # @param [Numeric] exclusive_maximum
          def initialize(exclusive_maximum)
            @exclusive_maximum = exclusive_maximum
          end

          # @param [Hash] _options
          # @return [Hash]
          def as_schema(**_options)
            { exclusiveMaximum: @exclusive_maximum }
          end

          # @param [Symbol] name
          # @param [ActiveModel::Validations] klass
          def register_validations(name, klass)
            klass.validates_numericality_of(
              name,
              less_than: @exclusive_maximum,
              allow_nil: true,
            )
          end
        end
      end
    end
  end
end
