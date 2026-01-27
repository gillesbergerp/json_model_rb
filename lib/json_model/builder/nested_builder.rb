# frozen_string_literal: true

require_relative('base_builder')

module JsonModel
  module Builder
    class NestedBuilder < BaseBuilder
      # @return [Hash]
      def as_schema
        builder.as_schema
      end

      # @return [Array<Type>]
      def referenced_schemas
        builder.referenced_schemas
      end

      protected

      # @return [BaseBuilder]
      def builder
        @builder ||= Builder.for(nested_type)
      end

      # @return [Type]
      def nested_type
        type.type
      end
    end
  end
end
