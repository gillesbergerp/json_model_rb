# frozen_string_literal: true

require_relative('../builder/format')
require_relative('../builder/max_length')
require_relative('../builder/min_length')
require_relative('../builder/pattern')

module JsonModel
  module Types
    class << self
      # @return [Types::Primitive::String]
      def string
        Primitive::String.new
      end
    end

    class Primitive
      class String < Primitive
        include(Builder::Format)
        include(Builder::MaxLength)
        include(Builder::MinLength)
        include(Builder::Pattern)

        def initialize
          super(types: [::String], schema_type: 'string')
        end
      end
    end
  end
end
