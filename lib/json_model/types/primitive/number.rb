# frozen_string_literal: true

require_relative('numeric')

module JsonModel
  module Types
    class << self
      # @return [Types::Primitive::Number]
      def number
        Primitive::Number.new
      end
    end

    class Primitive
      class Number < Numeric
        def initialize
          super(types: [Integer, Float], schema_type: 'number')
        end
      end
    end
  end
end
