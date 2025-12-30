# frozen_string_literal: true

module T
  class AnyOf
    # @param [Array<Class>] types
    # @param [Hash] options
    def initialize(*types, **options)
      @types = types
      @options = options
    end

    # @return [JsonModel::TypeSpec::Composition::AnyOf]
    def to_type_spec
      JsonModel::TypeSpec::Composition::AnyOf.new(
        *@types.map { |type| JsonModel::TypeSpec.resolve(type) },
        **@options,
      )
    end

    class << self
      # @param [Array] types
      # @param [Hash] options
      # @return [AnyOf]
      def [](*types, **options)
        AnyOf.new(*types, **options)
      end
    end
  end
end
