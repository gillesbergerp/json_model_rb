# frozen_string_literal: true

require('spec_helper')

RSpec.describe(JsonModel::TypeSpec::Composition::AllOf) do
  describe('#as_schema') do
    it('returns an all of schema') do
      expect(
        described_class.new(JsonModel::TypeSpec::Primitive::String.new).as_schema,
      )
        .to(
          eq(
            {
              allOf: [{ type: 'string' }],
            },
          ),
        )
    end
  end
end
