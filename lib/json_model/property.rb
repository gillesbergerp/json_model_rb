# frozen_string_literal: true

module JsonModel
  class Property
    attr_reader(:name, :default)

    # @param [Symbol] name
    # @param [TypeSpec] type
    # @param [Object, nil] default
    # @param [Hash] options
    def initialize(name, type:, default: nil, **options)
      @name = name
      @type = type
      @default = default
      @options = options
    end

    # @return [Hash]
    def as_schema
      {
        @name => @type.as_schema.merge({ default: default }.compact),
      }
    end
  end
end
