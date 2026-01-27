# frozen_string_literal: true

require_relative('builder')

module JsonModel
  module Builder
    module Composition
      class AnyOfBuilder < Builder
        # @param [Dry::Types::Intersection] type
        def initialize(type)
          super(type.type, :anyOf)
        end
      end
    end
  end
end
