# frozen_string_literal: true

require_relative('type_spec/primitive')

module JsonModel
  class TypeSpec
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
        return Primitive.new(type: type) if [String, Integer, Float, TrueClass, FalseClass].include?(type)

        raise(ArgumentError, "Unsupported type: #{type}")
      end
    end
  end
end
