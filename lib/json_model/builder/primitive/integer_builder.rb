# frozen_string_literal: true

require_relative('builder')

module JsonModel
  module Builder
    module Primitive
      class IntegerBuilder < Builder
        # @param [Dry::Types::Type] type
        def initialize(type)
          super(type, 'integer')
        end
      end
    end
  end
end
