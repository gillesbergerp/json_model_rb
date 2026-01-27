# frozen_string_literal: true

module JsonModel
  module Builder
    class BaseBuilder
      attr_reader(:type)

      # @param [Dry::Types::Type] type
      def initialize(type)
        @type = type
      end

      # @return [Hash]
      def as_schema
        raise(NotImplementedError)
      end

      # @return [Array<JsonModel::Builder::BaseBuilder>]
      def referenced_schemas
        []
      end
    end
  end
end
