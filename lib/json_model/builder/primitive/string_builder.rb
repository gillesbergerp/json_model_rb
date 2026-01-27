# frozen_string_literal: true

require_relative('builder')

module JsonModel
  module Builder
    module Primitive
      class StringBuilder < Builder
        # @param [Dry::Types::Type] type
        def initialize(type)
          super(type, 'string')
        end
      end
    end
  end
end
