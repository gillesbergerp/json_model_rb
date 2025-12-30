# frozen_string_literal: true

require_relative('type_spec/array')
require_relative('type_spec/composition')
require_relative('type_spec/const')
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

    # @param [::Object] json
    # @return [::Object, nil]
    def cast(json)
      json
    end

    class << self
      # @param [Object, Class] type
      # @return [TypeSpec]
      def resolve(type)
        case type
        when TypeSpec
          type
        when Class
          resolve_type_from_class(type)
        else
          if type.respond_to?(:to_type_spec)
            type.to_type_spec
          else
            raise(ArgumentError, "Unsupported type: #{type}")
          end
        end
      end

      private

      # @param [Object, Class] type
      # @return [TypeSpec]
      def resolve_type_from_class(type)
        if type == String
          Primitive::String.new
        elsif type == Integer
          Primitive::Integer.new
        elsif type == Float
          Primitive::Number.new
        elsif [TrueClass, FalseClass].include?(type)
          Primitive::Boolean.new
        elsif type == NilClass
          Primitive::Null.new
        elsif type < Schema
          TypeSpec::Object.new(type)
        else
          raise(ArgumentError, "Unsupported type: #{type}")
        end
      end
    end
  end
end
