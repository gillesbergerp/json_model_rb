# frozen_string_literal: true

module JsonModel
  module Types
    class << self
      # @param [Schema] type
      # @return [Object]
      def object(type)
        Object.new(type)
      end
    end

    class Object
      include(Type)
      include(Builder)
      include(Builder::RefMode)

      attr_reader(:type)

      # @param [Schema] type
      def initialize(type)
        @type = type
      end

      # @return [Hash]
      def as_schema
        super.merge(@type.as_schema(ref_mode: ref_mode))
      end

      # @return [::Array<Type>]
      def referenced_schemas
        if ref_mode == RefMode::LOCAL
          [@type]
        else
          []
        end
      end

      # @param [::Object] json
      # @return [::Object, nil]
      def cast(json)
        @type.from_json(**json)
      end
    end
  end
end
