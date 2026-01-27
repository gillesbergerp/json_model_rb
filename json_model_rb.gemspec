# frozen_string_literal: true

require_relative('lib/json_model/version')

Gem::Specification.new do |spec|
  spec.name = 'json_model_rb'
  spec.version = JsonModel::VERSION
  spec.summary = 'Generate JSON Schema from Dry::Struct models'
  spec.description = 'A gem that extends Dry::Struct with JSON Schema generation capabilities,'\
                     'supporting standard types, constraints, and polymorphic models.'
  spec.authors = ['Paul Gillesberger']
  spec.email = ['paulgillesberger@live.com']
  spec.files = Dir['lib/**/*.rb'] + Dir['spec/**/*'] + %w(README.md LICENSE)
  spec.homepage = 'https://github.com/gillesbergerp/json_model'
  spec.license = 'MIT'

  spec.required_ruby_version = '>= 3.1'
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rspec', '~> 3.0')
  spec.add_development_dependency('rubocop', '~> 1.82')
  spec.add_development_dependency('rubocop-rspec', '~> 3.8')
  spec.add_dependency('activesupport', '>= 6.0')
  spec.add_dependency('dry-struct', '~> 1.6', '>= 1.6.0')
  spec.add_dependency('dry-types', '~> 1.7', '>= 1.7.1')
  spec.add_dependency('dry-validation', '~> 1.8', '>= 1.8.0')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
