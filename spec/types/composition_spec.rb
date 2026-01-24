# frozen_string_literal: true

require('spec_helper')

RSpec.describe(JsonModel::Types::Composition) do
  describe('#as_schema') do
    it('returns schema of complex types') do
      expect(
        described_class
          .new(
            :allOf,
            JsonModel::Types.string,
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
            JsonModel::Types.object(
              Class.new do
                include(JsonModel::Schema)

                property(:foo, type: String)
                schema_id('https://example.com/schemas/foo.json')
              end,
            )
                            .as_external_ref,
          )
          .as_schema,
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
            JsonModel::Types.object(
              Class.new do
                include(JsonModel::Schema)

                property(:foo, type: String)

                def self.name
                  'Foo'
                end
              end,
            ).as_local_ref,
          ).as_schema,
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
