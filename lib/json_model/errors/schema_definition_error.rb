# frozen_string_literal: true

module JsonModel
  module Errors
    # Raised when a schema is declared incorrectly (e.g. an invalid discriminator).
    class SchemaDefinitionError < Error
    end
  end
end
