# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Primitive
      class Number < Numeric
        # @param [Hash] options
        def initialize(**options)
          super('number', **options)
        end
      end
    end
  end
end
