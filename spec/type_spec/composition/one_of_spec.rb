# frozen_string_literal: true

require('spec_helper')

RSpec.describe(JsonModel::TypeSpec::Composition::OneOf) do
  describe('#as_schema') do
    it('returns a one of schema') do
      expect(
        described_class.new(JsonModel::TypeSpec::Primitive::String.new).as_schema,
      )
        .to(
          eq(
            {
              oneOf: [{ type: 'string' }],
            },
          ),
        )
    end
  end
end
