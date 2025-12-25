# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Primitive < TypeSpec
      # @param [Class] type
      def initialize(type:)
        super()
        @type = type
      end
    end
  end
end
