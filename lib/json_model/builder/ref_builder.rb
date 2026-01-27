# frozen_string_literal: true

require_relative('base_builder')

module JsonModel
  module Builder
    class RefBuilder < NestedBuilder
      # @return [Hash]
      def as_schema
        case ref_mode
        when :local
          { '$ref': "#/$defs/#{type.name}" }
        when :external
          { '$ref': type.schema_id }
        else
          type.as_schema
        end
      end

      # @return [Array<Type>]
      def referenced_schemas
        if ref_mode == :local
          [type]
        else
          super
        end
      end

      # @return [Symbol]
      def ref_mode
        type.options[:mode]
      end
    end
  end
end
