# frozen_string_literal: true

module JsonModel
  module Types
    class << self
      # @return [Types::Primitive::Boolean]
      def boolean
        Primitive::Boolean.new
      end
    end

    class Primitive
      class Boolean < Primitive
        def initialize
          super(types: [TrueClass, FalseClass], schema_type: 'boolean')
        end
      end
    end
  end
end
