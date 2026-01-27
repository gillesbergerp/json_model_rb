# frozen_string_literal: true

require_relative('builder')

module JsonModel
  module Builder
    module Composition
      class SumBuilder < Builder
        # @param [Dry::Types::Sum] type
        def initialize(type)
          super(type, :anyOf)
        end
      end
    end
  end
end
