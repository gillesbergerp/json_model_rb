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
        subclass.meta_attributes.merge!(meta_attributes.dup)
        subclass.meta_attributes[:$ref] = schema_id
      end

      schema_id(JsonModel.config.schema_id_naming_strategy.call(self))
      schema_version(JsonModel.config.schema_version)
    end

    class_methods do
      # @param [String, nil] description
      # @return [String, nil]
      def description(description = nil)
        if description
          meta_attributes[:description] = description
        else
          meta_attributes[:description]
        end
      end

      # @param [String, nil] title
      # @return [String, nil]
      def title(title = nil)
        if title
          meta_attributes[:title] = title
        else
          meta_attributes[:title]
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

      # @param [Symbol, nil] version
      # @return [TrueClass, FalseClass]
      def schema_version(version = nil)
        if version.nil?
          meta_attributes[:$schema]
        else
          meta_attributes[:$schema] = SCHEMA_VERSIONS[version]
        end
      end

      # @return [Hash]
      def meta_attributes
        @meta_attributes ||=  {}
        @meta_attributes.merge!({ unevaluatedProperties: @schema&.strict? ? false : nil }.compact)
      end
    end
  end
end
