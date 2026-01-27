# frozen_string_literal: true

require_relative('../base_builder')

module JsonModel
  module Builder
    module Composition
      class Builder < BaseBuilder
        # @param [Dry::Types::Type] type
        # @param [Symbol] modifier
        def initialize(type, modifier)
          super(type)
          @modifier = modifier
        end

        # @return [Hash]
        def as_schema
          {
            @modifier => builders.map(&:as_schema).uniq,
          }
        end

        # @return [Array<JsonModel::Builder::BaseBuilder>]
        def referenced_schemas
          builders.flat_map(&:referenced_schemas).uniq
        end

        private

        # @return [Array<JsonModel::Builder::BaseBuilder>]
        def builders
          @builders ||= types(type).uniq.map { |type| JsonModel::Builder.for(type) }
        end

        # @param [Dry::Types::Type] type
        # @return [Array<Dry::Types::Type>]
        def types(type)
          if type.is_a?(Dry::Types::Composition)
            types(type.left) + types(type.right)
          else
            [type]
          end
        end
      end
    end
  end
end
