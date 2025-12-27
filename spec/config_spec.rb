# frozen_string_literal: true

require('spec_helper')

RSpec.describe(JsonModel::Config) do
  describe('#property_naming_strategy') do
    it('defaults to identity') do
      value = SecureRandom.uuid.to_sym
      expect(described_class.property_naming_strategy.call(value))
        .to(eq(value))
    end

    it('can be changed to a proc') do
      value = SecureRandom.uuid.to_sym
      JsonModel.configure { |config| config.property_naming_strategy = ->(value) { value.to_s.upcase.to_sym } }

      expect(described_class.property_naming_strategy.call(value))
        .to(eq(value.to_s.upcase.to_sym))
    end

    it('can be changed to pascal case') do
      JsonModel.configure { |config| config.property_naming_strategy = :pascal_case }

      expect(described_class.property_naming_strategy.call(:foo_bar))
        .to(eq('FooBar'))
    end

    it('can be changed to camel case') do
      JsonModel.configure { |config| config.property_naming_strategy = :camel_case }

      expect(described_class.property_naming_strategy.call(:foo_bar))
        .to(eq('fooBar'))
    end
  end
end
