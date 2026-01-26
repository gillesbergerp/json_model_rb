# frozen_string_literal: true

module JsonModel
  module Types
    module Builder
      module MaxLength
        extend(ActiveSupport::Concern)
        include(Builder)

        included do
          register_constraint(:max_length, Constraint)
        end

        class Constraint
          # @param [Numeric] max_length
          def initialize(max_length)
            @max_length = max_length
          end

          # @return [Hash]
          def as_schema
            { maxLength: @max_length }
          end

          # @param [Symbol] name
          # @param [ActiveModel::Validations] klass
          def register_validations(name, klass)
            klass.validates(
              name,
              length: { maximum: @max_length },
              allow_nil: true,
            )
          end
        end
      end
    end
  end
end
