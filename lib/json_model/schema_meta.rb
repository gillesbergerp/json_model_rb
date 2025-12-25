# frozen_string_literal: true

module JsonModel
  module SchemaMeta
    extend(ActiveSupport::Concern)

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
    end
  end
end
