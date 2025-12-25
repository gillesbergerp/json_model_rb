# frozen_string_literal: true

module JsonModel
  class Property
    attr_reader(:name, :default, :type, :optional)

    # @param [Symbol] name
    # @param [TypeSpec] type
    # @param [Object, nil] default
    # @param [Boolean] optional
    def initialize(name, type:, default: nil, optional: false)
      @name = name
      @type = type
      @default = default
      @optional = optional
    end

    # @return [Hash]
    def as_schema
      {
        self.alias => type.as_schema.merge({ default: default }.compact),
      }
    end

    # @param [ActiveModel::Validations]
    def register_validations(klass)
      if required?
        klass.validates(name, presence: true)
      end
      type.register_validations(name, klass)
    end

    # @return [Boolean]
    def required?
      !optional
    end

    # @return [Symbol]
    def alias
      name
    end
  end
end
