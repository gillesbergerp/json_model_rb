# frozen_string_literal: true

require_relative('builder')

module JsonModel
  module Builder
    module Composition
      class OneOfBuilder < Builder
        # @param [Dry::Types::Sum] type
        def initialize(type)
          super(type, :oneOf)
        end

        protected

        # @param [Dry::Types::Type] type
        # @return [Array<Dry::Types::Type>]
        def types(type)
          type.options[:mapping].values
        end
      end
    end
  end
end
