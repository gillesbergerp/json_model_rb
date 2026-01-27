# frozen_string_literal: true

require_relative('../base_builder')

module JsonModel
  module Builder
    module Primitive
      class Builder < BaseBuilder
        # @param [Dry::Types::Type] type
        # @param [String] schema_type
        def initialize(type, schema_type)
          super(type)
          @schema_type = schema_type
        end

        # @return [Hash]
        def as_schema
          {
            type: @schema_type,
          }
        end
      end
    end
  end
end
