# frozen_string_literal: true

module T
  module Enum
    class << self
      # @param [Array] args
      # @return [JsonModel::TypeSpec::Enum]
      def [](*args)
        JsonModel::TypeSpec::Enum.new(*args)
      end
    end
  end
end
