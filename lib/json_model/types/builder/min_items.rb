# frozen_string_literal: true

module JsonModel
  module Types
    module Builder
      module MinItems
        extend(ActiveSupport::Concern)
        include(Builder)

        included do
          register_constraint(:min_items, Constraint)
        end

        class Constraint
          # @param [Numeric] min_items
          def initialize(min_items)
            @min_items = min_items
          end

          # @param [Hash] _options
          # @return [Hash]
          def as_schema(**_options)
            { minItems: @min_items }
          end

          # @param [Symbol] name
          # @param [ActiveModel::Validations] klass
          def register_validations(name, klass)
            klass.validates(name, length: { minimum: @min_items }.compact, allow_nil: true)
          end
        end
      end
    end
  end
end
