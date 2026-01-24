# frozen_string_literal: true

module JsonModel
  module Types
    class << self
      # @param [::Array<Object>] types
      # @param [Hash] options
      # @return [Composition::AllOf]
      def all_of(*types, **options)
        Composition::AllOf.new(*types, **options)
      end
    end

    class Composition
      class AllOf < Composition
        # @param [Array<Object>] types
        # @param [Hash] options
        def initialize(*types, **options)
          super(:allOf, *types, **options)
        end

        # @param [::Object] json
        # @return [::Object, nil]
        def cast(json)
          if json.nil?
            return nil
          end

          types_for(json).map do |type|
            type.cast(json)
          rescue StandardError
            raise(Errors::TypeError, "Value #{json.inspect} cannot be cast to allOf type #{self}")
          end
        end
      end
    end
  end
end
