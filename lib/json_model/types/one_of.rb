# frozen_string_literal: true

module T
  class OneOf
    # @param [Array<Class>] types
    def initialize(*types)
      @types = types
    end

    # @return [JsonModel::TypeSpec::Composition::OneOf]
    def to_type_spec(**options)
      JsonModel::TypeSpec::Composition::OneOf.new(
        *@types.map { |type| JsonModel::TypeSpec.resolve(type) },
        **options,
      )
    end

    class << self
      # @param [Array] types
      # @return [OneOf]
      def [](*types)
        OneOf.new(*types)
      end
    end
  end
end
