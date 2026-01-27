# frozen_string_literal: true

require_relative('builder')

module JsonModel
  module Builder
    module Primitive
      class BooleanBuilder < Builder
        # @param [Dry::Types::Type] type
        def initialize(type)
          super(type, 'boolean')
        end
      end
    end
  end
end
