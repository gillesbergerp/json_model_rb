# frozen_string_literal: true

module JsonModel
  module Types
    module Type
      # @param [::Object] json
      # @return [::Object, nil]
      def cast(json)
        json
      end

      # @return [::Array<Type>]
      def referenced_schemas
        []
      end

      # @return [TrueClass, FalseClass]
      def required?
        @optional.nil? || !@optional
      end
    end
  end
end
