# frozen_string_literal: true

require('spec_helper')

RSpec.describe(JsonModel::TypeSpec::Primitive::Integer) do
  describe('#as_schema') do
    it('returns an integer schema') do
      expect(subject.as_schema)
        .to(eq({ type: 'integer' }))
    end
  end
end
