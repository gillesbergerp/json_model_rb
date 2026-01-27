# frozen_string_literal: true

module JsonModel
  module Types
    class << self
      # @param [Symbol] tag_key
      # @return [OneOf]
      def one_of(tag_key, &)
        builder = OneOf::Builder.new(tag_key)
        builder.instance_eval(&)
        builder.build
      end
    end

    class OneOf < Dry::Types::Constructor
      attr_reader(:tag_key, :mapping)

      # @return [Array]
      def to_ast
        [
          :one_of,
          {
            tag_key: options[:tag_key],
            mapping: options[:mapping].transform_values do |type|
              type.respond_to?(:to_ast) ? type.to_ast : type.class.name
            end,
            meta: meta,
          },
        ]
      end

      class Builder
        attr_reader(:tag_key, :mapping)

        # @param [Symbol] tag_key
        def initialize(tag_key)
          @tag_key = tag_key
          @mapping = {}
        end

        # @param [Array<Symbol>] tags
        # @param [Dry::Types::Type] type
        def on(*tags, type)
          tags.each { |tag| mapping[tag] = type }
        end

        # @return [OneOf]
        def build
          OneOf.new(Dry::Core::Constants::Undefined, tag_key: tag_key, mapping: mapping) do |input|
            tag = input[tag_key]
            type = mapping[tag]
            raise(Dry::Types::ConstraintError, "Unknown tag #{tag.inspect}") unless type

            type[input]
          end
        end
      end
    end
  end
end
