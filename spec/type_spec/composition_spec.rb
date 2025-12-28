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
                  type: 'object',
                  properties: { foo: { type: 'string' } },
                  required: %i(foo),
                  additionalProperties: false,
                },
              ],
            },
          ),
        )
    end

    it('uses external references') do
      expect(
        described_class
          .new(
            :allOf,
            Class.new do
              include(JsonModel::Schema)

              property(:foo, type: String)
              schema_id('https://example.com/schemas/foo.json')
            end,
          )
          .as_schema(ref_mode: JsonModel::RefMode::EXTERNAL),
      )
        .to(
          eq(
            {
              allOf: [
                { '$ref': 'https://example.com/schemas/foo.json' },
              ],
            },
          ),
        )
    end

    it('uses local references') do
      expect(
        described_class
          .new(
            :allOf,
            Class.new do
              include(JsonModel::Schema)

              property(:foo, type: String)

              def self.name
                'Foo'
              end
            end,
          )
          .as_schema(ref_mode: JsonModel::RefMode::LOCAL),
      )
        .to(
          eq(
            {
              allOf: [
                { '$ref': '#/$defs/Foo' },
              ],
            },
          ),
        )
    end
  end
end
