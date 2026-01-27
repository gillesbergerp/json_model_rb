# frozen_string_literal: true

require_relative('builder')

module JsonModel
  module Builder
    module Composition
      class OneOfBuilder < Builder
        # @param [Dry::Types::Sum] type
        def initialize(type)
          super(type.type, :oneOf)
        end
      end
    end
  end
end
