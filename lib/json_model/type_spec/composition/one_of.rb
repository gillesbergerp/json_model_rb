# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Composition
      class OneOf < Composition
        # @param [TypeSpec] types
        # @param [Hash] options
        def initialize(*types, **options)
          super(:oneOf, *types, **options)
        end

        # @param [::Object] json
        # @return [::Object, nil]
        def cast(json)
          if json.nil?
            return nil
          end

          types = @types.select do |type|
            type.cast(json)
          rescue StandardError
            false
          end

          case types.size
          when 0
            raise(Errors::TypeError, "No matching type found in OneOf for value: #{json.inspect}")
          when 1
            types.first.cast(json)
          else
            raise(Errors::TypeError, "Multiple matching types found in OneOf for value: #{json.inspect}")
          end
        end
      end
    end
  end
end
