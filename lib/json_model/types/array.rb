# frozen_string_literal: true

require_relative('builder/max_items')
require_relative('builder/min_items')
require_relative('builder/unique_items')

module JsonModel
  module Types
    class << self
      # @param [Object] type
      # @return [Array]
      def array(type)
        Array.new(type)
      end
    end

    class Array
      include(Type)
      include(Builder)
      include(Builder::MaxItems)
      include(Builder::MinItems)
      include(Builder::UniqueItems)

      # @param [Object] type
      def initialize(type)
        @type = Types.resolve(type)
      end

      # @param [Hash] options
      # @return [Hash]
      def as_schema(**options)
        super.merge(
          type: 'array',
          items: @type.as_schema(**options),
        )
      end

      # @return [Array<Type>]
      def referenced_schemas
        @type.referenced_schemas
      end

      # @param [::Object] json
      # @return [::Object, nil]
      def cast(json)
        if json.is_a?(Enumerable)
          json.map { |item| @type.cast(item) }
        else
          raise(Errors::TypeError, "Expected an array, got #{json.class} (#{json.inspect})")
        end
      end
    end
  end
end
