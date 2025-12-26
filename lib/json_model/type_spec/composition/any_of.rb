# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Composition
      class AnyOf < Composition
        # @param [TypeSpec] types
        # @param [Hash] options
        def initialize(*types, **options)
          super(:anyOf, *types, **options)
        end
      end
    end
  end
end
