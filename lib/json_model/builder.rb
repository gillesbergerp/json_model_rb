# frozen_string_literal: true

require_relative('builder/alias_builder')
require_relative('builder/array_builder')
require_relative('builder/composition')
require_relative('builder/constrained_builder')
require_relative('builder/default_builder')
require_relative('builder/enum_builder')
require_relative('builder/format_builder')
require_relative('builder/key_builder')
require_relative('builder/primitive')
require_relative('builder/ref_builder')
require_relative('builder/schema_builder')

require_relative('types')

module JsonModel
  module Builder
    class << self
      PRIMITIVE_TO_BUILDER = {
        Array => Builder::ArrayBuilder,
        FalseClass => Builder::Primitive::BooleanBuilder,
        Float => Builder::Primitive::NumberBuilder,
        Integer => Builder::Primitive::IntegerBuilder,
        NilClass => Builder::Primitive::NullBuilder,
        String => Builder::Primitive::StringBuilder,
        TrueClass => Builder::Primitive::BooleanBuilder,
        URI => Builder::FormatBuilder.for('uri'),
      }.freeze

      TYPE_TO_BUILDER = {
        Dry::Struct::Sum => Builder::Composition::SumBuilder,
        Dry::Types::Constrained => Builder::ConstrainedBuilder,
        Dry::Types::Constructor => Builder::NestedBuilder,
        Dry::Types::Default => Builder::DefaultBuilder,
        Dry::Types::Enum => Builder::EnumBuilder,
        Dry::Types::Intersection => Builder::Composition::IntersectionBuilder,
        Dry::Types::Intersection::Constrained => Builder::Composition::IntersectionBuilder,
        Dry::Types::Schema::Key => Builder::KeyBuilder,
        Dry::Types::Sum => Builder::Composition::SumBuilder,
        Dry::Types::Sum::Constrained => Builder::Composition::SumBuilder,
        JsonModel::Types::Alias => Builder::AliasBuilder,
        JsonModel::Types::AnyOf => Builder::Composition::AnyOfBuilder,
        JsonModel::Types::OneOf => Builder::Composition::OneOfBuilder,
        JsonModel::Types::Ref => Builder::RefBuilder,
      }.freeze

      # @param [Dry::Types::Type] type
      # @return [Builder::BaseBuilder]
      def for(type)
        if TYPE_TO_BUILDER.key?(type.class)
          TYPE_TO_BUILDER[type.class].new(type)
        elsif type.respond_to?(:meta) && type.meta[:format]
          Builder::FormatBuilder.for(type.meta[:format]).new(type)
        elsif type.respond_to?(:primitive) && PRIMITIVE_TO_BUILDER.key?(type.primitive)
          PRIMITIVE_TO_BUILDER[type.primitive].new(type)
        elsif type.is_a?(Class) && type < Schema
          SchemaBuilder.new(type)
        else
          raise("No builder available for type: #{type.inspect}")
        end
      end
    end
  end
end
