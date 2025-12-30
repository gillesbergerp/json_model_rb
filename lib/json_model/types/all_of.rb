# frozen_string_literal: true

module T
  class AllOf
    # @param [Array<Class>] types
    # @param [Hash] options
    def initialize(*types, **options)
      @types = types
      @options = options
    end

    # @return [JsonModel::TypeSpec::Composition::AllOf]
    def to_type_spec
      JsonModel::TypeSpec::Composition::AllOf.new(
        *@types.map { |type| JsonModel::TypeSpec.resolve(type) },
        **@options,
      )
    end

    class << self
      # @param [Array] types
      # @param [Hash] options
      # @return [AllOf]
      def [](*types, **options)
        AllOf.new(*types, **options)
      end
    end
  end
end
