# frozen_string_literal: true

module T
  class Integer
    # @param [Hash] options
    def initialize(**options)
      @options = options
    end

    # @return [JsonModel::TypeSpec::Composition::Primitive::Integer]
    def to_type_spec
      JsonModel::TypeSpec::Primitive::Integer.new(**@options)
    end

    class << self
      # @param [Hash] options
      # @return [T::Integer]
      def [](**options)
        Integer.new(**options)
      end
    end
  end
end
