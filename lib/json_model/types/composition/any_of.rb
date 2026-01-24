# frozen_string_literal: true

module JsonModel
  module Types
    class << self
      # @param [::Array<Object>] types
      # @param [Hash] options
      # @return [Composition::AnyOf]
      def any_of(*types, **options)
        Composition::AnyOf.new(*types, **options)
      end
    end

    class Composition
      class AnyOf < Composition
        # @param [Array<Object>] types
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

          type = types_for(json).detect do |type|
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
