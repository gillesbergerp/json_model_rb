# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Array < TypeSpec
      # @param [TypeSpec] type
      # @param [Integer, nil] min_items
      # @param [Integer, nil] max_items
      # @param [Boolean, nil] unique_items
      def initialize(type, min_items: nil, max_items: nil, unique_items: nil)
        super()
        @type = type
        @min_items = min_items
        @max_items = max_items
        @unique_items = unique_items
      end

      # @param [Hash] options
      # @return [Hash]
      def as_schema(**options)
        {
          type: 'array',
          items: @type.as_schema(**options),
          minItems: @min_items,
          maxItems: @max_items,
          uniqueItems: @unique_items,
        }.compact
      end

      # @param [Symbol] name
      # @param [ActiveModel::Validations] klass
      def register_validations(name, klass)
        super

        if @min_items || @max_items
          klass.validates(name, length: { minimum: @min_items, maximum: @max_items }.compact, allow_nil: true)
        end
        if @unique_items
          register_uniqueness_validation(name, klass)
        end
      end

      # @return [Array<TypeSpec>]
      def referenced_schemas
        @type.referenced_schemas
      end

      # @param [::Object] json
      # @return [::Object, nil]
      def cast(json)
        if json.is_a?(Enumerable)
          json.map { |item| @type.cast(item) }
        else
          raise(Errors::TypeError, "Expected an array, got #{json.class} (#{json.inspect})")
        end
      end

      private

      # @param [Symbol] name
      # @param [ActiveModel::Validations] klass
      def register_uniqueness_validation(name, klass)
        klass.validate do |record|
          duplicates = record.send(name)&.group_by(&:itself)&.select { |_k, v| v.size > 1 }&.keys
          if !duplicates.nil? && duplicates.any?
            record.errors.add(:tags, :uniqueness, message: "contains duplicates: #{duplicates.join(', ')}")
          end
        end
      end
    end
  end
end
