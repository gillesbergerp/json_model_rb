# frozen_string_literal: true

require_relative('types/constraint')
require_relative('types/builder')
require_relative('types/type')

require_relative('types/array')
require_relative('types/castable')
require_relative('types/composition')
require_relative('types/const')
require_relative('types/enum')
require_relative('types/object')
require_relative('types/primitive')

module JsonModel
  module Types
    TYPE_MAP = {
      ::Date => Types.date,
      ::DateTime => Types.date_time,
      ::FalseClass => Types.boolean,
      ::Float => Types.number,
      ::Integer => Types.integer,
      ::NilClass => Types.null,
      ::Regexp => Types.regexp,
      ::String => Types.string,
      ::Time => Types.time,
      ::TrueClass => Types.boolean,
      ::URI => Types.uri,
    }.freeze

    class << self
      # @param [::Object, Class] type
      # @return [Types::Type]
      def resolve(type)
        if type.is_a?(Types::Type)
          return type
        end

        if TYPE_MAP.key?(type)
          TYPE_MAP[type]
        elsif type.is_a?(Class) && type < Schema
          Types::Object.new(type)
        elsif type.is_a?(Types::Type) || (type.is_a?(Class) && type < Types::Type)
          type
        else
          raise(ArgumentError, "Unsupported type: #{type}")
        end
      end
    end
  end
end
