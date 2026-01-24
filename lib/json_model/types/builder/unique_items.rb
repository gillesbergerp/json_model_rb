# frozen_string_literal: true

module JsonModel
  module Types
    module Builder
      module UniqueItems
        extend(ActiveSupport::Concern)
        include(Builder)

        included do
          register_constraint(:unique_items, Constraint)
        end

        class Constraint
          # @param [Hash] _options
          # @return [Hash]
          def as_schema(**_options)
            { uniqueItems: true }
          end

          # @param [Symbol] name
          # @param [ActiveModel::Validations] klass
          def register_validations(name, klass)
            klass.validate do |record|
              duplicates = record.send(name)&.group_by(&:itself)&.select { |_k, v| v.size > 1 }&.keys
              if !duplicates.nil? && duplicates.any?
                record.errors.add(:tags, :uniqueness, message: "contains duplicates: #{duplicates.join(', ')}")
              end
            end
          end
        end
      end
    end
  end
end
