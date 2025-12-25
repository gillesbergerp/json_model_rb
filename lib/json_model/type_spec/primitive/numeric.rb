# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Primitive
      class Numeric < Primitive
        # @param [String] type
        # @param [Integer, nil] multiple_of
        def initialize(type, multiple_of: nil)
          super(type)
          @multiple_of = multiple_of
        end

        # @return [Hash]
        def as_schema
          super.merge({ multipleOf: @multiple_of }.compact)
        end

        # @param [Symbol] name
        # @param [ActiveModel::Validations] klass
        def register_validations(name, klass)
          super
          register_multiple_of_validation(name, klass, @multiple_of)
        end

        private

        # @param [Symbol] name
        # @param [ActiveModel::Validations] klass
        # @param [Integer, nil] multiple_of
        def register_multiple_of_validation(name, klass, multiple_of)
          if multiple_of.nil?
            return
          end

          klass.validate do |record|
            value = record.send(name)
            if value.present? && value % multiple_of != 0
              record.errors.add(name, "must be a multiple of #{multiple_of}")
            end
          end
        end
      end
    end
  end
end
