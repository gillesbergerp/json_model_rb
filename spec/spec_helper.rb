# frozen_string_literal: true

require('bundler/setup')
require('json_model')

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.after do
    JsonModel.reset_config!
  end
end
