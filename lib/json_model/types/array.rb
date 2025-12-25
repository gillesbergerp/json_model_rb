# frozen_string_literal: true

module T
  module Array
    class << self
      # @param [Class] type
      # @return [JsonModel::TypeSpec::Array]
      def [](type)
        JsonModel::TypeSpec::Array.new(
          JsonModel::TypeSpec.resolve(type),
        )
      end
    end
  end
end
