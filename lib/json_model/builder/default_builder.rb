# frozen_string_literal: true

require_relative('nested_builder')

module JsonModel
  module Builder
    class DefaultBuilder < NestedBuilder
      # @return [Hash]
      def as_schema
        super.merge(default: type.value)
      end
    end
  end
end
