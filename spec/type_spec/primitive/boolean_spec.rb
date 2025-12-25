# frozen_string_literal: true

require('spec_helper')

RSpec.describe(JsonModel::TypeSpec::Primitive::Boolean) do
  describe('#as_schema') do
    it('returns a boolean schema') do
      expect(subject.as_schema)
        .to(eq({ type: 'boolean' }))
    end
  end
end
