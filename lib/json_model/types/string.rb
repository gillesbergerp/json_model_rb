# frozen_string_literal: true

module T
  class String
    # @param [Hash] options
    def initialize(**options)
      @options = options
    end

    # @return [JsonModel::TypeSpec::Composition::Primitive::String]
    def to_type_spec
      JsonModel::TypeSpec::Primitive::String.new(**@options)
    end

    class << self
      # @param [Hash] options
      # @return [T::String]
      def [](**options)
        String.new(**options)
      end
    end
  end
end
