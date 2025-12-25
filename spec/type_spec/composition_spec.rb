# frozen_string_literal: true

require('spec_helper')

RSpec.describe(JsonModel::TypeSpec::Composition) do
  describe('#as_schema') do
    it('returns schema of complex types') do
      expect(
        described_class
          .new(
            :allOf,
            JsonModel::TypeSpec::Primitive::String.new,
            Class.new do
              include(JsonModel::Schema)
              property(:foo, type: String)
            end,
          )
          .as_schema,
      )
        .to(
          eq(
            {
              allOf: [
                { type: 'string' },
                {
                  properties: { foo: { type: 'string' } },
                  required: %i(foo),
                },
              ],
            },
          ),
        )
    end
  end
end
