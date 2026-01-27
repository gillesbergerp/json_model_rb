# frozen_string_literal: true

module JsonModel
  module Types
    class Alias < Dry::Types::Constructor
      # @return [Array]
      def to_ast
        [
          :alias,
          [
            options[:as],
            type.to_ast,
          ],
        ]
      end

      # @return [Symbol]
      def alias
        options[:as]
      end

      module Builder
        # @param [Symbol] name
        # @return [Alias]
        def as(name)
          Alias.new(self, as: name) { |input| input }
        end
      end
    end
  end
end

Dry::Types::Builder.prepend(JsonModel::Types::Alias::Builder)
