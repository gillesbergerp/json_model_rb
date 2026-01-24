# frozen_string_literal: true

module JsonModel
  module Types
    class Primitive
      class Numeric < Primitive
        include(Builder::ExclusiveMaximum)
        include(Builder::ExclusiveMinimum)
        include(Builder::Maximum)
        include(Builder::Minimum)
        include(Builder::MultipleOf)
      end
    end
  end
end
