# frozen_string_literal: true

require_relative('type_spec/array')
require_relative('type_spec/composition')
require_relative('type_spec/enum')
require_relative('type_spec/primitive')

module JsonModel
  class TypeSpec
    # @return [Hash]
    def as_schema
      raise(NotImplementedError)
    end

    # @param [Symbol] name
    # @param [ActiveModel::Validations] klass
    def register_validations(name, klass) end

    class << self
      # @param [Object, nil] type
      # @param [Hash] options
      # @return [TypeSpec]
      def resolve(type, **options)
        case type
        when NilClass
          TypeSpec::Enum.new(**options)
        when TypeSpec
          type
        when Class
          resolve_type_from_class(type, **options)
        else
          raise(ArgumentError, "Unsupported type: #{type}")
        end
      end

      private

      # @param [Object] type
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
        else
          raise(ArgumentError, "Unsupported type: #{type}")
        end
      end
    end
  end
end
