# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Primitive
      class Null < Primitive
        def initialize
          super('null')
        end
      end
    end
  end
end
