# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Primitive
      class String < Primitive
        def initialize(min_length: nil, max_length: nil, pattern: nil)
          super('string')

          @min_length = min_length
          @max_length = max_length
          @pattern = pattern
        end

        # @return [Hash]
        def as_schema
          super.merge(
            {
              minLength: @min_length,
              maxLength: @max_length,
              pattern: @pattern&.source,
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
          if @pattern
            klass.validates(name, format: { with: @pattern })
          end
        end
      end
    end
  end
end
