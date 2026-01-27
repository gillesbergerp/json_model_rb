# frozen_string_literal: true

require_relative('base_builder')

module JsonModel
  module Builder
    class NoOpBuilder < BaseBuilder
      # @return [Hash]
      def as_schema
        {}
      end
    end
  end
end
