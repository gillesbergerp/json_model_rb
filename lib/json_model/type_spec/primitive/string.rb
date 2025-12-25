# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Primitive
      class String < Primitive
        def initialize
          super('string')
        end
      end
    end
  end
end
