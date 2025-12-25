# frozen_string_literal: true

module JsonModel
  module Schema
    extend(ActiveSupport::Concern)
    include(Properties)
  end
end
