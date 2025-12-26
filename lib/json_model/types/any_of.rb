# frozen_string_literal: true

module T
  class AnyOf
    # @param [Array<Class>] types
    def initialize(*types)
      @types = types
    end

    # @return [JsonModel::TypeSpec::Composition::AnyOf]
    def to_type_spec(**options)
      JsonModel::TypeSpec::Composition::AnyOf.new(
        *@types.map { |type| JsonModel::TypeSpec.resolve(type) },
        **options,
      )
    end

    class << self
      # @param [Array] types
      # @return [AnyOf]
      def [](*types)
        AnyOf.new(*types)
      end
    end
  end
end
