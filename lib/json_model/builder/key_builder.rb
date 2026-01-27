# frozen_string_literal: true

require_relative('nested_builder')

module JsonModel
  module Builder
    class KeyBuilder < NestedBuilder
      # @return [Hash]
      def as_schema
        {
          self.alias => builder.as_schema,
        }
      end

      # @return [FalseClass, TrueClass]
      def optional?
        type.optional?
      end

      # @return [Symbol]
      def alias
        if type.respond_to?(:alias)
          type.alias
        else
          JsonModel.config.property_naming_strategy.call(type.name)
        end
      end
    end
  end
end
