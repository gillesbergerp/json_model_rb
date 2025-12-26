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
      class_attribute(:meta_attributes, instance_writer: false, default: {})
      class_attribute(:ref_schema, instance_writer: false)

      # @param [Class] subclass
      def self.inherited(subclass)
        super
        subclass.meta_attributes[:'$ref'] = schema_id
      end

      schema_id(name)
    end

    class_methods do
      # @param [String, nil] id
      # @return [String, nil]
      def schema_id(id = nil)
        if id
          meta_attributes[:'$id'] = URI.parse(id).to_s
        else
          meta_attributes[:'$id']
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

      # @param [Symbol, nil] version
      # @return [Boolean]
      def schema_version(version = nil)
        if version.nil?
          meta_attributes[:'$schema']
        else
          meta_attributes[:'$schema'] = SCHEMA_VERSIONS[version]
        end
      end
    end
  end
end
