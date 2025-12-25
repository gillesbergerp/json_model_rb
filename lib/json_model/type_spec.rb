# frozen_string_literal: true

require_relative('type_spec/primitive')

module JsonModel
  class TypeSpec
    # @return [Hash]
    def as_schema
      raise(NotImplementedError)
    end

    class << self
      # @param [Object] type
      # @return [TypeSpec]
      def resolve(type)
        case type
        when TypeSpec
          type
        when Class
          resolve_type_from_class(type)
        else
          raise(ArgumentError, "Unsupported type: #{type}")
        end
      end

      private

      # @param [Object] type
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
        else
          raise(ArgumentError, "Unsupported type: #{type}")
        end
      end
    end
  end
end
