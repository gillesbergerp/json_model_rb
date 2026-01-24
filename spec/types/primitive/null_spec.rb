# frozen_string_literal: true

require('spec_helper')

RSpec.describe(JsonModel::Types::Primitive::Null) do
  describe('#as_schema') do
    it('returns a null schema') do
      expect(subject.as_schema)
        .to(eq({ type: 'null' }))
    end
  end
end
