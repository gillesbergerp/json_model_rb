# frozen_string_literal: true

module JsonModel
  module Types
    module Constraint
      # @param [Hash] options
      # @return [Hash]
      def as_schema(**options)
        raise(NotImplementedError)
      end

      # @param [Symbol] name
      # @param [ActiveModel::Validations] klass
      def register_validations(name, klass)
        raise(NotImplementedError)
      end
    end
  end
end
