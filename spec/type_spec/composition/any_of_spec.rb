# frozen_string_literal: true

require('spec_helper')

RSpec.describe(JsonModel::TypeSpec::Composition::AnyOf) do
  describe('#as_schema') do
    it('returns an any of schema') do
      expect(
        described_class.new(JsonModel::TypeSpec::Primitive::String.new).as_schema,
      )
        .to(
          eq(
            {
              anyOf: [{ type: 'string' }],
            },
          ),
        )
    end
  end
end
