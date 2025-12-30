# frozen_string_literal: true

module T
  class Enum
    # @param [Array<Object>] values
    def initialize(*values)
      @values = values
    end

    # @return [JsonModel::TypeSpec::Enum]
    def to_type_spec
      JsonModel::TypeSpec::Enum.new(*@values)
    end

    class << self
      # @param [Array] args
      # @return [Enum]
      def [](*args)
        Enum.new(*args)
      end
    end
  end
end
