# frozen_string_literal: true

module T
  class Number
    # @param [Hash] options
    def initialize(**options)
      @options = options
    end

    # @return [JsonModel::TypeSpec::Composition::Primitive::Number]
    def to_type_spec
      JsonModel::TypeSpec::Primitive::Number.new(**@options)
    end

    class << self
      # @param [Hash] options
      # @return [Number]
      def [](**options)
        Number.new(**options)
      end
    end
  end
end
