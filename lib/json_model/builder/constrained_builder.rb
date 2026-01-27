# frozen_string_literal: true

require_relative('nested_builder')

module JsonModel
  module Builder
    class ConstrainedBuilder < NestedBuilder
      CONSTRAINT_MAPPING = {
        eql?: {
          String => { key: :const },
        },
        format?: {
          String => { key: :pattern, transform: lambda(&:source) },
        },
        gt?: {
          Integer => { key: :exclusiveMinimum },
        },
        gteq?: {
          Integer => { key: :minimum },
        },
        lt?: {
          Integer => { key: :exclusiveMaximum },
        },
        lteq?: {
          Integer => { key: :maximum },
        },
        max_size?: {
          String => { key: :maxLength },
          Array => { key: :maxItems },
        },
        min_size?: {
          String => { key: :minLength },
          Array => { key: :minItems },
        },
        unique?: {
          Array => { key: :uniqueItems, transform: ->(_v) { true } },
        },
      }.freeze

      # @return [Hash]
      def as_schema
        if type.meta[:format]
          super
        else
          super.merge(*extract_constraints)
        end
      end

      private

      # @return [Array<Hash>]
      def extract_constraints
        extract_rules(type.rule)
          .map { |rule| extract_constraint(rule.to_ast) }
          .compact
      end

      # @param [Dry::Types::Rule] rule
      # @return [Array<Dry::Types::Rule>]
      def extract_rules(rule)
        if rule.respond_to?(:rules)
          rule.rules.flat_map { |rule| extract_rules(rule) }
        else
          [rule]
        end
      end

      # @param [Array] ast
      # @return [Hash, nil]
      def extract_constraint(ast)
        predicate, args = ast.last
        if CONSTRAINT_MAPPING.key?(predicate)
          mapping = CONSTRAINT_MAPPING.dig(predicate, type.primitive) || CONSTRAINT_MAPPING[predicate].values.first
          {
            mapping[:key] => mapping
                               .fetch(:transform, ->(v) { v })
                               .call(args.first.last),
          }
        end
      end
    end
  end
end
