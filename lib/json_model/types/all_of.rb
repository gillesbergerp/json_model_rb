# frozen_string_literal: true

module T
  module AllOf
    class << self
      # @param [Array] args
      # @return [JsonModel::TypeSpec::Composition::AllOf]
      def [](*args)
        JsonModel::TypeSpec::Composition::AllOf.new(
          *args.map { |type| JsonModel::TypeSpec.resolve(type) },
        )
      end
    end
  end
end
