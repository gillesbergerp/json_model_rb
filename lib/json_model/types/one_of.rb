# frozen_string_literal: true

module T
  class OneOf
    # @param [Array<Class>] types
    # @param [Hash] options
    def initialize(*types, **options)
      @types = types
      @options = options
    end

    # @return [JsonModel::TypeSpec::Composition::OneOf]
    def to_type_spec
      JsonModel::TypeSpec::Composition::OneOf.new(
        *@types.map { |type| JsonModel::TypeSpec.resolve(type) },
        **@options,
      )
    end

    class << self
      # @param [Array] types
      # @param [Hash] options
      # @return [OneOf]
      def [](*types, **options)
        OneOf.new(*types, **options)
      end
    end
  end
end
