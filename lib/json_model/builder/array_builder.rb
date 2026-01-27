# frozen_string_literal: true

require_relative('nested_builder')

module JsonModel
  module Builder
    class ArrayBuilder < NestedBuilder
      # @return [Hash]
      def as_schema
        {
          type: 'array',
          items: builder.as_schema,
        }
      end

      protected

      # @return [Type]
      def nested_type
        type.member
      end
    end
  end
end
