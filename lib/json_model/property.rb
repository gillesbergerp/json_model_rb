# frozen_string_literal: true

module JsonModel
  class Property
    attr_reader(:name)

    # @param [Symbol] name
    # @param [TypeSpec] type
    # @param [Hash] options
    def initialize(name, type:, **options)
      @name = name
      @type = type
      @options = options
    end

    # @return [Hash]
    def as_schema
      {
        @name => @type.as_schema,
      }
    end
  end
end
