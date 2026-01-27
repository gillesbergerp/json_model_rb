# frozen_string_literal: true

require_relative('base_builder')

module JsonModel
  module Builder
    class FormatBuilder < BaseBuilder
      class << self
        # @param [String] format
        # @return [Factory]
        def for(format)
          Factory.new(format)
        end
      end

      class Factory
        attr_reader(:format)

        # @param [String] format
        def initialize(format)
          @format = format
        end

        # @param [Dry::Types::Type] type
        # @return [FormatBuilder]
        def new(type)
          FormatBuilder.new(type, format)
        end
      end

      # @param [Dry::Types::Type] type
      # @param [Symbol] format
      def initialize(type, format)
        super(type)
        @format = format
      end

      # @return [Hash]
      def as_schema
        {
          type: 'string',
          format: @format,
        }
      end
    end
  end
end
