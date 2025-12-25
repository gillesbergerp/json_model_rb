# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Primitive
      class Boolean < Primitive
        def initialize
          super('boolean')
        end
      end
    end
  end
end
