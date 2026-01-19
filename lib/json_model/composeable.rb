# frozen_string_literal: true

module JsonModel
  module Composeable
    extend(ActiveSupport::Concern)

    class_methods do
      # @return [Array]
      def composed_types
        @composed_types ||= []
      end

      # @param [Object] type
      # @param [Symbol] ref_mode
      def compose(type, ref_mode: RefMode::LOCAL)
        composed_types << {
          type: TypeSpec.resolve(type),
          ref_mode: ref_mode,
        }
      end

      # @return [Array<JsonModel::TypeSpec::Composition>]
      def composed_type_defs
        composed_types.select { |type| type[:ref_mode] == RefMode::LOCAL }.flat_map { |it| it[:type].referenced_schemas }
      end

      # @return [Array<Hash>]
      def composed_types_as_schema
        composed_types.each_with_object({}) do |it, agg|
          agg.deep_merge!(it[:type].as_schema(ref_mode: it[:ref_mode]))
        end
      end
    end
  end
end
