# frozen_string_literal: true

module T
  class Const
    # @param [String] value
    def initialize(value)
      @value = value
    end

    # @return [JsonModel::TypeSpec::Const]
    def to_type_spec
      JsonModel::TypeSpec::Const.new(*@value)
    end

    class << self
      # @param [Array] args
      # @return [Const]
      def [](*args)
        Const.new(*args)
      end
    end
  end
end
