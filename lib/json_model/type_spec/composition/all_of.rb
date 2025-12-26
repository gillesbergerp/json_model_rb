# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Composition
      class AllOf < Composition
        # @param [TypeSpec] types
        # @param [Hash] options
        def initialize(*types, **options)
          super(:allOf, *types, **options)
        end
      end
    end
  end
end
