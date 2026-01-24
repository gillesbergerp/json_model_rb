# frozen_string_literal: true

module JsonModel
  module Types
    module Builder
      module Minimum
        extend(ActiveSupport::Concern)
        include(Builder)

        included do
          register_constraint(:minimum, Constraint)
        end

        class Constraint
          # @param [Numeric] minimum
          def initialize(minimum)
            @minimum = minimum
          end

          # @param [Hash] _options
          # @return [Hash]
          def as_schema(**_options)
            { minimum: @minimum }
          end

          # @param [Symbol] name
          # @param [ActiveModel::Validations] klass
          def register_validations(name, klass)
            klass.validates_numericality_of(
              name,
              greater_than_or_equal_to: @minimum,
              allow_nil: true,
            )
          end
        end
      end
    end
  end
end
