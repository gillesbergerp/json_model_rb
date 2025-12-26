# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Composition
      class OneOf < Composition
        # @param [TypeSpec] types
        # @param [Hash] options
        def initialize(*types, **options)
          super(:oneOf, *types, **options)
        end
      end
    end
  end
end
