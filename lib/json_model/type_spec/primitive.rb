# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Primitive < TypeSpec
      # @param [::Array<Class>] types
      # @param [String] schema_type
      def initialize(types:, schema_type:)
        super()
        @types = types
        @schema_type = schema_type
      end

      # @param [Hash] _options
      # @return [Hash]
      def as_schema(**_options)
        { type: @schema_type }
      end

      # @param [::Object] json
      # @return [::Object, nil]
      def cast(json)
        if json.nil?
          nil
        elsif @types.any? { |type| json.is_a?(type) }
          json
        else
          raise(Errors::TypeError, "Expected one of #{@type.join('/')}, got #{json.class} (#{json.inspect})")
        end
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
