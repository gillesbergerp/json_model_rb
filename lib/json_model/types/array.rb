# frozen_string_literal: true

module T
  class Array
    # @param [Class] type
    def initialize(type)
      @type = type
    end

    # @return [JsonModel::TypeSpec::Array]
    def to_type_spec(**options)
      JsonModel::TypeSpec::Array.new(
        JsonModel::TypeSpec.resolve(@type),
        **options,
      )
    end

    class << self
      # @param [Class] type
      # @return [Array]
      def [](type)
        Array.new(type)
      end
    end
  end
end
