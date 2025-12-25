# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Primitive
      class Number < Primitive
        def initialize
          super('number')
        end
      end
    end
  end
end
