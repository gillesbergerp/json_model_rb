# frozen_string_literal: true

require_relative('builder')

module JsonModel
  module Builder
    module Composition
      class AnyOfBuilder < Builder
        # @param [Dry::Types::Intersection] type
        def initialize(type)
          super(type, :anyOf)
        end

        protected

        # @param [Dry::Types::Type] type
        # @return [Array<Dry::Types::Type>]
        def types(type)
          type.options[:mapping].values.uniq
        end
      end
    end
  end
end
