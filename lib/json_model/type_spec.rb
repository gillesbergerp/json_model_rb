# frozen_string_literal: true

require_relative('type_spec/array')
require_relative('type_spec/castable')
require_relative('type_spec/composition')
require_relative('type_spec/const')
require_relative('type_spec/enum')
require_relative('type_spec/object')
require_relative('type_spec/primitive')

module JsonModel
  class TypeSpec
    TYPE_MAP = {
      Date => Castable.new(format: 'date') { |v| ::DateTime.iso8601(v) },
      DateTime => Castable.new(format: 'date-time') { |v| ::DateTime.iso8601(v) },
      FalseClass => Primitive::Boolean.new,
      Float => Primitive::Number.new,
      Integer => Primitive::Integer.new,
      NilClass => Primitive::Null.new,
      Regexp => Castable.new(format: 'regex') { |v| Regexp.new(v) },
      String => Primitive::String.new,
      Time => Castable.new(format: 'time') { |v| ::Time.iso8601(v) },
      TrueClass => Primitive::Boolean.new,
      URI => Castable.new(format: 'uri') { |v| URI.parse(v) },
    }.freeze

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
        if type.is_a?(TypeSpec)
          return type
        end

        if TYPE_MAP.key?(type)
          TYPE_MAP[type]
        elsif type.respond_to?(:to_type_spec)
          type.to_type_spec
        elsif type.is_a?(Class) && type < Schema
          TypeSpec::Object.new(type)
        else
          raise(ArgumentError, "Unsupported type: #{type}")
        end
      end

      private

      # @param [Object, Class] type
      # @return [TypeSpec]
      def resolve_type_from_class(type)
        if TYPE_MAP.key?(type)
          TYPE_MAP[type]
        elsif type < Schema
          TypeSpec::Object.new(type)
        else
          raise(ArgumentError, "Unsupported type: #{type}")
        end
      end
    end
  end
end
