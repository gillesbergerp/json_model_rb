# frozen_string_literal: true

module JsonModel
  module Types
    class Composition
      include(Type)
      include(Builder)

      attr_reader(:types, :modifier, :discriminator)

      # @param [Symbol] modifier
      # @param [::Array<Object>] types
      # @param [Symbol, nil] discriminator
      def initialize(modifier, *types, discriminator: nil)
        @types = types.map { |type| Types.resolve(type) }
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

      # @return [Array<Type>]
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
          if !type.is_a?(Object)
            raise('Discriminator property can only be used with Object types')
          end

          discriminator_property = type.type.properties[discriminator]
          discriminator_values = if discriminator_property&.type.is_a?(Types::Const)
                                   [discriminator_property.type.value]
                                 elsif discriminator_property&.type.is_a?(Types::Enum)
                                   discriminator_property.type.values
                                 else
                                   raise('Discriminator property must be of type Const or Enum')
                                 end
          discriminator_values.each do |value|
            hash[value] ||= []
            hash[value] << type
          end
        end
      end

      # @param [::Object] json
      # @return [::Array<Type>]
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
