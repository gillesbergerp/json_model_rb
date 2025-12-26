# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Primitive < TypeSpec
      # @param [String] type
      def initialize(type)
        super()
        @type = type
      end

      # @param [Hash] _options
      # @return [Hash]
      def as_schema(**_options)
        { type: @type }
      end
    end
  end
end

require_relative('primitive/boolean')
require_relative('primitive/numeric')
require_relative('primitive/integer')
require_relative('primitive/null')
require_relative('primitive/number')
require_relative('primitive/string')
