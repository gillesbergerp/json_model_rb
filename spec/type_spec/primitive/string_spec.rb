# frozen_string_literal: true

require('spec_helper')

RSpec.describe(JsonModel::TypeSpec::Primitive::String) do
  describe('#as_schema') do
    it('returns a string schema') do
      expect(subject.as_schema)
        .to(eq({ type: 'string' }))
    end
  end
end
