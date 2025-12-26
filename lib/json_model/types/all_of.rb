# frozen_string_literal: true

module T
  class AllOf
    # @param [Array<Class>] types
    def initialize(*types)
      @types = types
    end

    # @return [JsonModel::TypeSpec::Composition::AllOf]
    def to_type_spec(**options)
      JsonModel::TypeSpec::Composition::AllOf.new(
        *@types.map { |type| JsonModel::TypeSpec.resolve(type) },
        **options,
      )
    end

    class << self
      # @param [Array] types
      # @return [AllOf]
      def [](*types)
        AllOf.new(*types)
      end
    end
  end
end
