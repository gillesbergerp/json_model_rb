# frozen_string_literal: true

require('active_support/core_ext/string')
require_relative('config/options')

module JsonModel
  module Config
    extend(JsonModel::Config::Options)

    PROPERTY_NAMING_STRATEGIES = {
      identity: lambda(&:to_sym),
      camel_case: ->(property_name) { property_name.to_s.tr('-', '_').camelize(:lower) },
      pascal_case: ->(property_name) { property_name.to_s.tr('-', '_').camelize },
    }.freeze

    SCHEMA_ID_NAMING_STRATEGIES = {
      class_name: ->(klass) { klass.name.demodulize },
      kebab_case_class_name: ->(klass) { klass.name.demodulize.underscore.tr('_', '-') },
      none: ->(_) {},
      snake_case_class_name: ->(klass) { klass.name.demodulize.underscore },
    }.freeze

    option(:property_naming_strategy, default: :identity) do |value|
      if value.is_a?(Proc)
        value
      else
        PROPERTY_NAMING_STRATEGIES[value]
      end
    end

    option(:schema_id_base_uri, default: nil)

    option(:schema_id_naming_strategy, default: :none) do |value|
      if value.is_a?(Proc)
        value
      else
        SCHEMA_ID_NAMING_STRATEGIES[value]
      end
    end

    option(:validate_after_instantiation, default: true)
  end
end
