# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Composition < TypeSpec
      attr_reader(:types, :modifier, :discriminator)

      # Resolves each member type before instantiating the concrete composition
      # (e.g. +Types::AllOf[Foo, Bar]+). Inherited by {AllOf}, {AnyOf} and {OneOf}.
      # @return [Composition]
      def self.[](*types, **options)
        new(*types.map { |type| resolve(type) }, **options)
      end

      # @param [Symbol] modifier
      # @param [::Array<TypeSpec>] types
      def initialize(modifier, *types, discriminator: nil)
        super()
        @types = types
        @modifier = modifier
        @discriminator = discriminator
      end

      # @param [Hash] options
      # @return [Hash]
      def as_schema(**options)
        {
          modifier => types.map { |type| type.as_schema(**options) },
        }
      end

      # @return [Array<TypeSpec>]
      def referenced_schemas
        types.flat_map(&:referenced_schemas)
      end

      # @param [::Object] json
      # @return [::Object, nil]
      def cast(json)
        raise(NotImplementedError)
      end

      protected

      # @return [Hash, nil]
      def type_map
        if discriminator.nil?
          return nil
        end

        @type_map ||= types.each_with_object({}) do |type, hash|
          discriminator_values_for(type).each do |value|
            hash[value] ||= []
            hash[value] << type
          end
        end
      end

      # @param [TypeSpec] type
      # @return [::Array]
      def discriminator_values_for(type)
        if !type.is_a?(Object)
          raise(Errors::SchemaDefinitionError, 'Discriminator property can only be used with Object types')
        end

        property = type.type.properties[discriminator]
        case property&.type
        when Const
          [property.type.value]
        when Enum
          property.type.values
        else
          raise(Errors::SchemaDefinitionError, 'Discriminator property must be of type Const or Enum')
        end
      end

      # @param [::Object] json
      # @return [::Array<TypeSpec>]
      def types_for(json)
        if type_map.nil?
          types
        else
          type_map[json[discriminator]]
        end
      end
    end
  end
end

require_relative('composition/all_of')
require_relative('composition/any_of')
require_relative('composition/one_of')
