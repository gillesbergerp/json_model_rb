# frozen_string_literal: true

require('active_model')
require('active_support/concern')
require('active_support/core_ext/class/attribute')
require('active_support/descendants_tracker')
require('uri')
require('json_model/config')
require('json_model/errors')
require('json_model/properties')
require('json_model/property')
require('json_model/ref_mode')
require('json_model/schema_meta')
require('json_model/schema')
require('json_model/type_spec')
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
