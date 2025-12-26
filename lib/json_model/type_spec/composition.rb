# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Composition < TypeSpec
      # @param [Symbol] modifier
      # @param [TypeSpec] types
      def initialize(modifier, *types)
        super()
        @types = types
        @modifier = modifier
      end

      # @param [Hash] options
      # @return [Hash]
      def as_schema(**options)
        {
          @modifier => @types.map { |type| type.as_schema(**options) },
        }
      end

      # @return [Array<TypeSpec>]
      def referenced_schemas
        @types.flat_map(&:referenced_schemas)
      end
    end
  end
end

require_relative('composition/all_of')
