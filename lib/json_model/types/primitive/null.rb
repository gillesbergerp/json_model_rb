# frozen_string_literal: true

module JsonModel
  module Types
    class << self
      # @return [Types::Primitive::Null]
      def null
        Primitive::Null.new
      end
    end

    class Primitive
      class Null < Primitive
        def initialize
          super(types: [NilClass], schema_type: 'null')
        end
      end
    end
  end
end
