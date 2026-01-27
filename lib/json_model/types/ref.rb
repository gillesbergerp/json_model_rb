# frozen_string_literal: true

module JsonModel
  module Types
    class Ref < Dry::Types::Constructor
      # @return [Array]
      def to_ast
        [
          :ref,
          [
            options[:mode],
            type.to_ast,
          ],
        ]
      end

      module Builder
        # @return [Ref]
        def external
          Ref.new(self, mode: :external) { |input| input }
        end

        # @return [Ref]
        def local
          Ref.new(self, mode: :local) { |input| input }
        end
      end
    end
  end
end

Dry::Types::Builder.prepend(JsonModel::Types::Ref::Builder)
