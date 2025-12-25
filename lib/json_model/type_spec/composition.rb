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

      # @return [Hash]
      def as_schema
        {
          @modifier => @types.map(&:as_schema),
        }
      end
    end
  end
end

require_relative('composition/all_of')
