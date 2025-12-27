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

  describe('#validate_after_instantiation') do
    it('defaults to true') do
      expect(JsonModel.config.validate_after_instantiation)
        .to(eq(true))
    end

    it('can be changed to false') do
      JsonModel.configure { |config| config.validate_after_instantiation = false }

      expect(JsonModel.config.validate_after_instantiation)
        .to(eq(false))
    end
  end

  describe('#schema_id_base_uri') do
    it('defaults to nil') do
      expect(JsonModel.config.schema_id_base_uri)
        .to(be_nil)
    end

    it('can be changed to false') do
      JsonModel.configure { |config| config.schema_id_base_uri = 'https://example.com/schemas/' }

      expect(JsonModel.config.schema_id_base_uri)
        .to(eq('https://example.com/schemas/'))
    end
  end

  describe('#schema_id_naming_strategy') do
    let(:klass) do
      Class.new do
        def self.name
          'Baz::FooBar'
        end
      end
    end

    it('defaults to none') do
      expect(JsonModel.config.schema_id_naming_strategy.call(klass))
        .to(be_nil)
    end

    it('can be changed to class_name') do
      JsonModel.configure { |config| config.schema_id_naming_strategy = :class_name }

      expect(JsonModel.config.schema_id_naming_strategy.call(klass))
        .to(eq('FooBar'))
    end

    it('can be changed to kebab_case_class_name') do
      JsonModel.configure { |config| config.schema_id_naming_strategy = :kebab_case_class_name }

      expect(JsonModel.config.schema_id_naming_strategy.call(klass))
        .to(eq('foo-bar'))
    end

    it('can be changed to snake_case_class_name') do
      JsonModel.configure { |config| config.schema_id_naming_strategy = :snake_case_class_name }

      expect(JsonModel.config.schema_id_naming_strategy.call(klass))
        .to(eq('foo_bar'))
    end

    it('can use a custom proc') do
      JsonModel.configure { |config| config.schema_id_naming_strategy = ->(klass) { klass.name.downcase } }

      expect(JsonModel.config.schema_id_naming_strategy.call(klass))
        .to(eq('baz::foobar'))
    end
  end
end
