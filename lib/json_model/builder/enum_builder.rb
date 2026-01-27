# frozen_string_literal: true

require_relative('base_builder')

module JsonModel
  module Builder
    class EnumBuilder < BaseBuilder
      # @return [Hash]
      def as_schema
        {
          enum: type.values,
        }
      end
    end
  end
end
