# frozen_string_literal: true

module JsonModel
  module Types
    module Builder
      module Pattern
        extend(ActiveSupport::Concern)
        include(Builder)

        included do
          register_constraint(:pattern, Constraint)
        end

        class Constraint
          # @param [Regexp] pattern
          def initialize(pattern)
            @pattern = pattern
          end

          # @return [Hash]
          def as_schema
            { pattern: @pattern.source }
          end

          # @param [Symbol] name
          # @param [ActiveModel::Validations] klass
          def register_validations(name, klass)
            klass.validates(name, format: { with: @pattern }, allow_nil: true)
          end
        end
      end
    end
  end
end
