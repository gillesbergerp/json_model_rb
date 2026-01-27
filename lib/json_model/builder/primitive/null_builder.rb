# frozen_string_literal: true

require_relative('builder')

module JsonModel
  module Builder
    module Primitive
      class NullBuilder < Builder
        # @param [Dry::Types::Type] type
        def initialize(type)
          super(type, 'null')
        end
      end
    end
  end
end
