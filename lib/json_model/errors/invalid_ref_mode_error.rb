# frozen_string_literal: true

module JsonModel
  module Errors
    class InvalidRefModeError < Error
      # @param [Symbol] ref_mode
      def initialize(ref_mode)
        super("Invalid ref_mode: #{ref_mode}.")
      end
    end
  end
end
