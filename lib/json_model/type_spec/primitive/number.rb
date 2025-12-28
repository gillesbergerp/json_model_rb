# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Primitive
      class Number < Numeric
        # @param [Hash] options
        def initialize(**options)
          super(types: [Float], schema_type: 'number', **options)
        end
      end
    end
  end
end
