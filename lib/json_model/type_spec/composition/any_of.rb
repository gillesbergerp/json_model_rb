# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Composition
      class AnyOf < Composition
        # @param [TypeSpec] types
        # @param [Hash] options
        def initialize(*types, **options)
          super(:anyOf, *types, **options)
        end

        # @param [::Object] json
        # @return [::Object, nil]
        def cast(json)
          if json.nil?
            return nil
          end

          type = @types.detect do |type|
            type.cast(json)
          rescue StandardError
            false
          end
          if type.nil?
            raise(Errors::TypeError, "No matching type found in AnyOf for value: #{json.inspect}")
          else
            type.cast(json)
          end
        end
      end
    end
  end
end
