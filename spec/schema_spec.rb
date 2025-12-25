# frozen_string_literal: true

require('spec_helper')

RSpec.describe(JsonModel::Schema) do
  describe('.initialize') do
    let(:klass) do
      Class.new do
        include(JsonModel::Schema)
        property(:foo, type: String)
      end
    end

    it('succeeds without providing attributes') do
      expect { klass.new }.not_to(raise_error)
    end

    it('sets attribute values') do
      instance = klass.new(foo: 'bar')

      expect(instance.foo)
        .to(eq('bar'))
    end

    it('raises an error for unknown attributes') do
      expect { klass.new(bar: 'baz') }
        .to(raise_error(JsonModel::Errors::UnknownAttributeError))
    end
  end

  describe('#valid?') do
    let(:klass) do
      Class.new do
        include(JsonModel::Schema)
        property(:foo, type: String, min_length: 3)
      end
    end

    it('returns false for invalid values') do
      expect(klass.new(foo: 'ba').valid?)
        .to(be(false))
    end

    it('returns true for valid values') do
      expect(klass.new(foo: 'bar').valid?)
        .to(be(true))
    end
  end

  describe('.as_schema') do
    let(:klass) do
      Class.new do
        include(JsonModel::Schema)
      end
    end

    it('returns an empty schema') do
      expect(klass.as_schema)
        .to(eq({}))
    end

    it('includes the schema id') do
      klass.schema_id('https://example.com/schemas/example.json')

      expect(klass.as_schema)
        .to(
          eq(
            {
              '$id': 'https://example.com/schemas/example.json',
            },
          ),
        )
    end

    it('returns properties as schema') do
      klass.property(:foo, type: String)
      klass.property(:bar, type: Float, optional: true)
      klass.property(:baz, type: T::Enum[1, 'a', nil])
      klass.property(:bam, type: T::AllOf[String, Float])

      expect(klass.as_schema)
        .to(
          eq(
            {
              properties: {
                bam: {
                  allOf: [{ type: 'string' }, { type: 'number' }],
                },
                bar: { type: 'number' },
                baz: { enum: [1, 'a', nil] },
                foo: { type: 'string' },
              },
              required: %i(bam baz foo),
            },
          ),
        )
    end

    context('inheritance') do
      let(:child) do
        Class.new(klass) do
          schema_id('https://example.com/schemas/child.json')
        end
      end

      it('uses $ref for inherited schemas if they have a schema id') do
        klass.schema_id('https://example.com/schemas/example.json')
        expect(child.as_schema)
          .to(
            eq(
              {
                '$id': 'https://example.com/schemas/child.json',
                '$ref': 'https://example.com/schemas/example.json',
              },
            ),
          )
      end

      it('merges properties from parent classes without schema ids') do
        klass.property(:foo, type: String)
        child.property(:bar, type: Float)

        expect(child.as_schema)
          .to(
            eq(
              {
                '$id': 'https://example.com/schemas/child.json',
                properties: {
                  bar: { type: 'number' },
                  foo: { type: 'string' },
                },
                required: %i(bar foo),
              },
            ),
          )
      end
    end
  end
end
