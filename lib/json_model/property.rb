# frozen_string_literal: true

module JsonModel
  class Property
    attr_reader(:name, :default, :type, :optional, :alias)

    # @param [Symbol] name
    # @param [TypeSpec] type
    # @param [Object, nil] default
    # @param [Boolean] optional
    # @param [Symbol] ref_mode
    # @param [Symbol, nil] as
    def initialize(name, type:, default: nil, optional: false, ref_mode: RefMode::INLINE, as: nil)
      @name = name
      @type = type
      @default = default
      @optional = optional
      @ref_mode = ref_mode
      @alias = as || JsonModel.config.property_naming_strategy.call(name).to_sym
    end

    # @param [Hash] options
    # @return [Hash]
    def as_schema(**options)
      schema = type.as_schema(**options, ref_mode: @ref_mode)
      # A `$ref` is a standalone reference; attaching a default to it is meaningless
      # (and ignored by most validators), so only inline schemas carry defaults.
      if !schema.key?(:$ref)
        schema = schema.merge({ default: default }.compact)
      end

      { self.alias => schema }
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

    # @return [Array]
    def referenced_schemas
      if @ref_mode == RefMode::LOCAL
        type.referenced_schemas
      else
        []
      end
    end
  end
end
