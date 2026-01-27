# frozen_string_literal: true

require_relative('builder')

module JsonModel
  module Builder
    module Composition
      class IntersectionBuilder < Builder
        # @param [Dry::Types::Intersection] type
        def initialize(type)
          super(type, :allOf)
        end
      end
    end
  end
end
