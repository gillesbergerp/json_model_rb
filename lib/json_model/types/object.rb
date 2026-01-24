# frozen_string_literal: true

module JsonModel
  module Types
    class Object
      include(Type)
      include(Builder)

      attr_reader(:type)

      # @param [Schema] type
      def initialize(type)
        @type = type
      end

      # @param [Hash] options
      # @return [Hash]
      def as_schema(**options)
        @type.as_schema(**options)
      end

      # @return [::Array<Type>]
      def referenced_schemas
        [@type]
      end

      # @param [::Object] json
      # @return [::Object, nil]
      def cast(json)
        @type.from_json(**json)
      end
    end
  end
end
