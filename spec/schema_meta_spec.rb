# frozen_string_literal: true

require('spec_helper')

RSpec.describe(JsonModel::SchemaMeta) do
  describe('.schema_id') do
    let(:klass) do
      Class.new do
        include(JsonModel::SchemaMeta)
      end
    end

    it('is nil by default') do
      expect(klass.schema_id)
        .to(be_nil)
    end

    it('can be changed') do
      klass.schema_id('foo')

      expect(klass.schema_id)
        .to(eq('foo'))
    end

    it('respects the schema_id_base_uri') do
      JsonModel.configure { |config| config.schema_id_base_uri = 'http://example.com/schemas/' }
      klass.schema_id('foo')

      expect(klass.schema_id)
        .to(eq('http://example.com/schemas/foo'))
    end

    it('raises an error if the schema id is invalid') do
      expect { klass.schema_id('http://example .com') }
        .to(raise_error(URI::InvalidURIError))
    end
  end

  describe('.schema_version') do
    let(:klass) do
      Class.new do
        include(JsonModel::SchemaMeta)
      end
    end

    it('is nil by default') do
      expect(klass.schema_version)
        .to(be_nil)
    end

    it('can be changed') do
      klass.schema_version(:draft202012)

      expect(klass.schema_version)
        .to(eq('https://json-schema.org/draft/2020-12/schema'))
    end
  end

  describe('.description') do
    let(:klass) do
      Class.new do
        include(JsonModel::SchemaMeta)
      end
    end

    it('is nil by default') do
      expect(klass.description)
        .to(be_nil)
    end

    it('can be changed') do
      klass.description('This is a test description.')

      expect(klass.description)
        .to(eq('This is a test description.'))
    end
  end

  describe('.title') do
    let(:klass) do
      Class.new do
        include(JsonModel::SchemaMeta)
      end
    end

    it('is nil by default') do
      expect(klass.title)
        .to(be_nil)
    end

    it('can be changed') do
      klass.title('This is a test title.')

      expect(klass.title)
        .to(eq('This is a test title.'))
    end
  end

  describe('.additional_properties') do
    let(:klass) do
      Class.new do
        include(JsonModel::SchemaMeta)
      end
    end

    it('is missing by default') do
      expect(klass.meta_attributes)
        .to(eq({}))
    end

    it('can be changed') do
      klass.additional_properties(true)

      expect(klass.meta_attributes)
        .to(eq({ additionalProperties: true }))
    end
  end

  describe('.additional_properties') do
    let(:klass) do
      Class.new do
        include(JsonModel::SchemaMeta)
      end
    end

    it('is missing by default') do
      expect(klass.meta_attributes)
        .to(eq({}))
    end

    it('can be changed') do
      klass.unevaluated_properties(true)

      expect(klass.meta_attributes)
        .to(eq({ unevaluatedProperties: true }))
    end
  end
end
