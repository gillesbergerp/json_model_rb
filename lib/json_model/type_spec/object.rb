# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Object < TypeSpec
      attr_reader(:type)

      # @param [Schema] type
      def initialize(type)
        super()
        @type = type
      end

      # @param [Hash] options
      # @return [Hash]
      def as_schema(**options)
        type.as_schema(**options)
      end

      # @return [Array<TypeSpec>]
      def referenced_schemas
        [type]
      end

      # @param [::Object] json
      # @return [::Object, nil]
      def cast(json)
        type.from_json(**json)
      end
    end
  end
end
