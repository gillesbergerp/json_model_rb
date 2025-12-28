# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Primitive
      class Null < Primitive
        def initialize
          super(types: [NilClass], schema_type: 'null')
        end
      end
    end
  end
end
