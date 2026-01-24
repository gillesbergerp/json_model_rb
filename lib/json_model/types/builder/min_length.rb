# frozen_string_literal: true

module JsonModel
  module Types
    module Builder
      module MinLength
        extend(ActiveSupport::Concern)
        include(Builder)

        included do
          register_constraint(:min_length, Constraint)
        end

        class Constraint
          # @param [Numeric] min_length
          def initialize(min_length)
            @min_length = min_length
          end

          # @param [Hash] _options
          # @return [Hash]
          def as_schema(**_options)
            { minLength: @min_length }
          end

          # @param [Symbol] name
          # @param [ActiveModel::Validations] klass
          def register_validations(name, klass)
            klass.validates(
              name,
              length: { minimum: @min_length },
              allow_nil: true,
            )
          end
        end
      end
    end
  end
end
