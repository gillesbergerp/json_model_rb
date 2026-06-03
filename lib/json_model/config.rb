# frozen_string_literal: true

require('active_support/core_ext/string')

module JsonModel
  # Holds the global configuration for the gem. A single instance is exposed via
  # {JsonModel.config} and mutated through {JsonModel.configure}.
  class Configuration
    PROPERTY_NAMING_STRATEGIES = {
      identity: lambda(&:to_sym),
      camel_case: ->(property_name) { property_name.to_s.tr('-', '_').camelize(:lower) },
      pascal_case: ->(property_name) { property_name.to_s.tr('-', '_').camelize },
    }.freeze

    SCHEMA_ID_NAMING_STRATEGIES = {
      class_name: ->(klass) { klass.name.demodulize },
      kebab_case_class_name: ->(klass) { klass.name.demodulize.underscore.tr('_', '-') },
      none: ->(_klass) {},
      snake_case_class_name: ->(klass) { klass.name.demodulize.underscore },
    }.freeze

    attr_reader(:property_naming_strategy, :schema_id_naming_strategy)

    attr_accessor(:schema_id_base_uri, :schema_version, :validate_after_instantiation)

    def initialize
      reset!
    end

    # Restores every option to its default value.
    def reset!
      self.property_naming_strategy = :identity
      self.schema_id_base_uri = nil
      self.schema_id_naming_strategy = :none
      self.schema_version = nil
      self.validate_after_instantiation = true
    end

    # @param [Symbol, Proc] value
    def property_naming_strategy=(value)
      @property_naming_strategy = resolve_strategy(PROPERTY_NAMING_STRATEGIES, value)
    end

    # @param [Symbol, Proc] value
    def schema_id_naming_strategy=(value)
      @schema_id_naming_strategy = resolve_strategy(SCHEMA_ID_NAMING_STRATEGIES, value)
    end

    private

    # @param [Hash] strategies
    # @param [Symbol, Proc] value
    # @return [Proc]
    def resolve_strategy(strategies, value)
      return value if value.is_a?(Proc)

      strategies.fetch(value) do
        raise(ArgumentError, "Unknown strategy: #{value.inspect}")
      end
    end
  end
end
