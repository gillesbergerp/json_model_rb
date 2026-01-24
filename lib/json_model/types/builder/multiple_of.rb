# frozen_string_literal: true

module JsonModel
  module Types
    module Builder
      module MultipleOf
        extend(ActiveSupport::Concern)
        include(Builder)

        included do
          register_constraint(:multiple_of, Constraint)
        end

        class Constraint
          # @param [Numeric] multiple_of
          def initialize(multiple_of)
            @multiple_of = multiple_of
          end

          # @param [Hash] _options
          # @return [Hash]
          def as_schema(**_options)
            { multipleOf: @multiple_of }
          end

          # @param [Symbol] name
          # @param [ActiveModel::Validations] klass
          def register_validations(name, klass)
            multiple_of = @multiple_of
            klass.validate do |record|
              value = record.send(name)
              if value.present? && value % multiple_of != 0
                record.errors.add(name, :multiple_of, message: "must be a multiple of #{@multiple_of}")
              end
            end
          end
        end
      end
    end
  end
end
