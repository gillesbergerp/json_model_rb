# frozen_string_literal: true

module JsonModel
  module Types
    module Builder
      module MaxItems
        extend(ActiveSupport::Concern)
        include(Builder)

        included do
          register_constraint(:max_items, Constraint)
        end

        class Constraint
          # @param [Numeric] max_items
          def initialize(max_items)
            @max_items = max_items
          end

          # @param [Hash] _options
          # @return [Hash]
          def as_schema(**_options)
            { maxItems: @max_items }
          end

          # @param [Symbol] name
          # @param [ActiveModel::Validations] klass
          def register_validations(name, klass)
            klass.validates(name, length: { maximum: @max_items }.compact, allow_nil: true)
          end
        end
      end
    end
  end
end
