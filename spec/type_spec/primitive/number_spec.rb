# frozen_string_literal: true

require('spec_helper')

RSpec.describe(JsonModel::TypeSpec::Primitive::Number) do
  describe('#as_schema') do
    it('returns a number schema') do
      expect(subject.as_schema)
        .to(eq({ type: 'number' }))
    end
  end
end
