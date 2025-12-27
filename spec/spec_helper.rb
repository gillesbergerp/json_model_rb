# frozen_string_literal: true

require('bundler/setup')
require('json_model')

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.after do
    JsonModel.configure do |json_model_config|
      JsonModel.config.defaults.each { |key, value| json_model_config.send("#{key}=", value) }
    end
  end
end
