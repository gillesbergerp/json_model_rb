# frozen_string_literal: true

module JsonModel
  class Property
    # @param [Symbol] name
    # @param [Hash] options
    def initialize(name, **options)
      @name = name
      @options = options
    end
  end
end
