# frozen_string_literal: true

require_relative('lib/json_model/version')

Gem::Specification.new do |spec|
  spec.name = 'json_model_rb'
  spec.version = JsonModel::VERSION
  spec.summary = 'Declarative JSON Schema DSL with Sorbet and ActiveModel integration'
  spec.description = 'Define JSON schemas as Ruby modules using a DSL'
  spec.authors = ['Paul Gillesberger']
  spec.email = ['paulgillesberger@live.com']
  spec.files = Dir['lib/**/*.rb'] + Dir['spec/**/*'] + %w(README.md LICENSE.txt)
  spec.homepage = 'https://github.com/gillesbergerp/json_model'
  spec.license = 'MIT'

  spec.required_ruby_version = '>= 3.1'
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rspec', '~> 3.0')
  spec.add_development_dependency('rubocop', '~> 1.82')
  spec.add_runtime_dependency('activesupport', '>= 6.0')
end
