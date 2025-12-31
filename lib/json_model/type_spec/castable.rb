# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Castable < TypeSpec
      # @param [String] format
      # @param [Proc] cast_block
      def initialize(format:, &cast_block)
        super()
        @format = format
        @cast_block = cast_block
      end

      # @param [Hash] _options
      # @return [Hash]
      def as_schema(**_options)
        {
          type: 'string',
          format: @format,
        }
      end

      # @param [::Object] json
      # @return [::Object, nil]
      def cast(json)
        if json.nil?
          nil
        else
          @cast_block.call(json)
        end
      end
    end
  end
end
