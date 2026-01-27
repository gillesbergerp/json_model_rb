# frozen_string_literal: true

module JsonModel
  module Logic
    module Predicates
      module Methods
        # @param [Array] value
        # @return [FalseClass, TrueClass]
        def unique?(value)
          value.respond_to?(:uniq) && value.uniq.size == value.size
        end
      end
    end
  end
end

Dry::Logic::Predicates::Methods.prepend(JsonModel::Logic::Predicates::Methods)
