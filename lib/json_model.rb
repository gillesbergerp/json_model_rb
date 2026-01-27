# frozen_string_literal: true

require('active_support/concern')
require('active_support/core_ext/class/attribute')
require('active_support/descendants_tracker')
require('dry-struct')
require('dry-validation')
require('uri')
require('json_model/config')
require('json_model/errors')
require('json_model/predicates')
require('json_model/schema')
require('json_model/types')
require('json_model/version')

module JsonModel
  class << self
    # @return [Config]
    def configure(&)
      yield(Config)
    end

    # @return [Config]
    def config
      Config
    end
  end
end
