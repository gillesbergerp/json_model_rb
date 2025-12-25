# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Primitive < TypeSpec
      # @param [String] type
      def initialize(type)
        super()
        @type = type
      end

      # @return [Hash]
      def as_schema
        { type: @type }
      end
    end
  end
end

require_relative('primitive/boolean')
require_relative('primitive/integer')
require_relative('primitive/number')
require_relative('primitive/string')
