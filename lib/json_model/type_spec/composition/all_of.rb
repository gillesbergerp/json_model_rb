# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Composition
      class AllOf < Composition
        # @param [TypeSpec] types
        def initialize(*types)
          super(:allOf, *types)
        end
      end
    end
  end
end
