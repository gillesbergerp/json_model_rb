# frozen_string_literal: true

module T
  class Array
    # @param [Class] type
    # @param [Hash] options
    def initialize(type, **options)
      @type = type
      @options = options
    end

    # @return [JsonModel::TypeSpec::Array]
    def to_type_spec
      JsonModel::TypeSpec::Array.new(
        JsonModel::TypeSpec.resolve(@type),
        **@options,
      )
    end

    class << self
      # @param [Class] type
      # @param [Hash] options
      # @return [Array]
      def [](type, **options)
        Array.new(type, **options)
      end
    end
  end
end
