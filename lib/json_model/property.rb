# frozen_string_literal: true

module JsonModel
  class Property
    attr_reader(:name, :type, :alias)

    # @param [Symbol] name
    # @param [Types::Type] type
    # @param [Symbol, nil] as
    def initialize(name, type:, as: nil)
      @name = name
      @type = type
      @alias = as || JsonModel.config.property_naming_strategy.call(name).to_sym
    end

    # @return [Hash]
    def as_schema
      {
        self.alias => type
                        .as_schema
                        .merge({ default: default }.compact),
      }
    end

    # @param [ActiveModel::Validations]
    def register_validations(klass)
      if required?
        klass.validates(name, presence: true)
      end
      type.register_validations(name, klass)
    end

    # @return [::Object, nil]
    def default
      type.default
    end

    # @return [TrueClass, FalseClass]
    def required?
      type.required?
    end

    # @return [Array]
    def referenced_schemas
      type.referenced_schemas
    end
  end
end
