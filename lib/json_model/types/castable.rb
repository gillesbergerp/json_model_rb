# frozen_string_literal: true

module JsonModel
  module Types
    class << self
      # @return [Castable]
      def date
        Castable.new(format: 'date') { |v| ::DateTime.iso8601(v) }
      end

      # @return [Castable]
      def date_time
        Castable.new(format: 'date-time') { |v| ::DateTime.iso8601(v) }
      end

      # @return [Castable]
      def regexp
        Castable.new(format: 'regex') { |v| Regexp.new(v) }
      end

      # @return [Castable]
      def time
        Castable.new(format: 'time') { |v| ::Time.iso8601(v) }
      end

      # @return [Castable]
      def uri
        Castable.new(format: 'uri') { |v| URI.parse(v) }
      end
    end

    class Castable
      include(Type)
      include(Builder)

      # @param [String] format
      # @param [Proc] cast_block
      def initialize(format:, &cast_block)
        @format = format
        @cast_block = cast_block
      end

      # @return [Hash]
      def as_schema
        super.merge(
          type: 'string',
          format: @format,
        )
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
