# frozen_string_literal: true

require_relative('type_spec/array')
require_relative('type_spec/composition')
require_relative('type_spec/enum')
require_relative('type_spec/object')
require_relative('type_spec/primitive')

module JsonModel
  class TypeSpec
    # @param [Hash] options
    # @return [Hash]
    def as_schema(**options)
      raise(NotImplementedError)
    end

    # @param [Symbol] name
    # @param [ActiveModel::Validations] klass
    def register_validations(name, klass) end

    # @return [Array<TypeSpec>]
    def referenced_schemas
      []
    end

    class << self
      # @param [Object, Class] type
      # @param [Hash] options
      # @return [TypeSpec]
      def resolve(type, **options)
        case type
        when TypeSpec
          type
        when Class
          resolve_type_from_class(type, **options)
        when T::AllOf, T::AnyOf, T::Boolean, T::OneOf, T::Array, T::Enum
          type.to_type_spec(**options)
        else
          raise(ArgumentError, "Unsupported type: #{type}")
        end
      end

      private

      # @param [Object, Class] type
      # @param [Hash] options
      # @return [TypeSpec]
      def resolve_type_from_class(type, **options)
        if type == String
          Primitive::String.new(**options)
        elsif type == Integer
          Primitive::Integer.new(**options)
        elsif type == Float
          Primitive::Number.new(**options)
        elsif [TrueClass, FalseClass].include?(type)
          Primitive::Boolean.new(**options)
        elsif type == NilClass
          Primitive::Null.new(**options)
        elsif type < Schema
          TypeSpec::Object.new(type, **options)
        else
          raise(ArgumentError, "Unsupported type: #{type}")
        end
      end
    end
  end
end
