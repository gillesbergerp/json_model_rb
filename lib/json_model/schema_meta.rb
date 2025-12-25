# frozen_string_literal: true

module JsonModel
  module SchemaMeta
    extend(ActiveSupport::Concern)

    included do
      class_attribute(:meta_attributes, instance_writer: false, default: {})
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
