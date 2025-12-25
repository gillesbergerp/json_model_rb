# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Primitive
      class String < Primitive
        def initialize(min_length: nil, max_length: nil)
          super('string')

          @min_length = min_length
          @max_length = max_length
        end

        # @return [Hash]
        def as_schema
          super.merge(
            {
              minLength: @min_length,
              maxLength: @max_length,
            }.compact,
          )
        end

        # @param [Symbol] name
        # @param [ActiveModel::Validations]
        def register_validations(name, klass)
          super

          if !@min_length.nil? || !@max_length.nil?
            klass.validates(name, length: { minimum: @min_length, maximum: @max_length }.compact)
          end
        end
      end
    end
  end
end
