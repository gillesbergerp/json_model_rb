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

    it('raises an error if the schema id is invalid') do
      expect { klass.schema_id(123) }
        .to(raise_error(URI::InvalidURIError))
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
end
