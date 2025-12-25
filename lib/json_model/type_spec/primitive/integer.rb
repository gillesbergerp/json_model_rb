# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Primitive
      class Integer < Primitive
        def initialize
          super('integer')
        end
      end
    end
  end
end
