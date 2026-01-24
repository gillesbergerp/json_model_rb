# frozen_string_literal: true

module JsonModel
  module Types
    module Builder
      extend(ActiveSupport::Concern)

      class_methods do
        def register_constraint(name, builder)
          define_method(name) { |*args, **kwargs| register(builder.new(*args, **kwargs)) }
          define_singleton_method(name) { |*args, **kwargs| new.register(builder.new(*args, **kwargs)) }
        end
      end

      # @return [Builder]
      def optional
        @optional = true
        self
      end

      # @return [Array<Builder>]
      def constraints
        @constraints ||= []
      end

      # @param [Hash] options
      # @return [Hash]
      def as_schema(**options)
        constraints.map { |builder| builder.as_schema(**options) }.reduce(:merge) || {}
      end

      # @param [Symbol] name
      # @param [ActiveModel::Validations] klass
      def register_validations(name, klass)
        constraints.each { |builder| builder.register_validations(name, klass) }
      end

      # @param [Constraint] constraint
      # @return [Builder]
      def register(constraint)
        constraints << constraint
        self
      end
    end
  end
end

require_relative('builder/exclusive_maximum')
require_relative('builder/exclusive_minimum')
require_relative('builder/maximum')
require_relative('builder/minimum')
require_relative('builder/multiple_of')
