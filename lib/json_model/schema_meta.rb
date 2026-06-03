# frozen_string_literal: true

module JsonModel
  module SchemaMeta
    extend(ActiveSupport::Concern)

    SCHEMA_VERSIONS = {
      draft4: 'http://json-schema.org/draft-04/schema#',
      draft6: 'http://json-schema.org/draft-06/schema#',
      draft7: 'http://json-schema.org/draft-07/schema#',
      draft201909: 'https://json-schema.org/draft/2019-09/schema',
      draft202012: 'https://json-schema.org/draft/2020-12/schema',
    }.freeze

    included do
      # @param [Class] subclass
      def self.inherited(subclass)
        super
        subclass.schema_id(JsonModel.config.schema_id_naming_strategy.call(subclass))
        subclass.schema_version(JsonModel.config.schema_version)
        subclass.meta_attributes[:$ref] = schema_id
      end

      schema_id(JsonModel.config.schema_id_naming_strategy.call(self))
      schema_version(JsonModel.config.schema_version)
    end

    class_methods do
      # @return [Hash]
      def meta_attributes
        @meta_attributes ||= {}
      end

      # Plain metadata keywords share one getter/setter shape: called without an
      # argument they read the stored value, called with one they write it.
      %i(title description).each do |attribute|
        define_method(attribute) do |value = nil|
          if value.nil?
            meta_attributes[attribute]
          else
            meta_attributes[attribute] = value
          end
        end
      end

      # @param [String, nil] id
      # @return [String, nil]
      def schema_id(id = nil)
        if id
          meta_attributes[:$id] = URI.parse("#{JsonModel.config.schema_id_base_uri}#{id}").to_s
        else
          meta_attributes[:$id]
        end
      end

      # @param [Boolean, nil] value
      # @return [Boolean]
      def additional_properties(value = nil)
        if value.nil?
          meta_attributes[:additionalProperties] || false
        else
          meta_attributes[:additionalProperties] = value
        end
      end

      # @param [Boolean, nil] value
      # @return [Boolean]
      def unevaluated_properties(value = nil)
        if value.nil?
          meta_attributes[:unevaluatedProperties] || false
        else
          meta_attributes[:unevaluatedProperties] = value
        end
      end

      # @param [Symbol, nil] version
      # @return [Boolean]
      def schema_version(version = nil)
        if version.nil?
          meta_attributes[:$schema]
        else
          meta_attributes[:$schema] = SCHEMA_VERSIONS[version]
        end
      end
    end
  end
end
