# frozen_string_literal: true

require('spec_helper')

RSpec.describe(JsonModel::Schema) do
  describe('.initialize') do
    let(:klass) do
      Class.new(Dry::Struct) do
        include(JsonModel::Schema)

        attribute?(:foo, JsonModel::Types::String.optional)

        def self.name
          'Foo'
        end
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

    it('raises an error for unknown attributes when additional properties are not allowed') do
      klass.schema(klass.schema.strict)

      expect { klass.new(bar: 'baz') }
        .to(raise_error(Dry::Struct::Error))
    end

    it('does not raise an error for unknown attributes when additional properties are allowed') do
      klass.new(bar: 'baz')
    end
  end

  describe('.new') do
    before do
      stub_const(
        'Foo',
        Class.new(Dry::Struct) do
          include(JsonModel::Schema)

          attribute(:foo_bar, JsonModel::Types::String.as(:fooBar))
        end,
      )

      stub_const(
        'Bar',
        Class.new(Foo),
      )
    end

    it('parent can be instantiated from json') do
      instance = Foo.new({ fooBar: 'baz' })
      expect(instance.foo_bar).to(eq('baz'))
    end

    it('child can be instantiated from json') do
      instance = Bar.new({ fooBar: 'baz' })
      expect(instance.foo_bar).to(eq('baz'))
    end
  end

  describe('.as_schema') do
    let(:klass) do
      Class.new(Dry::Struct) do
        include(JsonModel::Schema)
      end
    end

    it('returns an empty schema') do
      expect(klass.as_schema)
        .to(eq({ type: 'object' }))
    end

    it('includes the schema id') do
      klass.schema_id('https://example.com/schemas/example.json')

      expect(klass.as_schema)
        .to(
          eq(
            {
              '$id': 'https://example.com/schemas/example.json',
              type: 'object',
            },
          ),
        )
    end

    it('returns properties as schema') do
      klass.schema_id('https://example.com/schemas/example.json')
      klass.attribute(:foo, JsonModel::Types::String)
      klass.attribute(:bar, JsonModel::Types::Float.optional)
      klass.attribute(:baz, JsonModel::Types::String.enum(1, 'a', nil))
      klass.attribute(:bam, JsonModel::Types::Array.of(JsonModel::Types::String & JsonModel::Types::Float))
      klass.attribute(:bal, klass.external.optional)

      expect(klass.as_schema)
        .to(
          eq(
            {
              '$id': 'https://example.com/schemas/example.json',
              type: 'object',
              properties: {
                bal: {
                  anyOf: [
                    { type: 'null' },
                    { '$ref': 'https://example.com/schemas/example.json' },
                  ],
                },
                bam: {
                  type: 'array',
                  items: {
                    allOf: [{ type: 'string' }, { type: 'number' }],
                  },
                },
                bar: {
                  anyOf: [
                    { type: 'null' },
                    { type: 'number' },
                  ],
                },
                baz: { enum: [1, 'a', nil] },
                foo: { type: 'string' },
              },
              required: %i(bam baz foo),
            },
          ),
        )
    end

    it('collects local references in $defs') do
      klass.attribute(
        :foo,
        Class.new(Dry::Struct) do
          include(JsonModel::Schema)

          attribute(:foo, JsonModel::Types::String)
        end,
      )
      klass.attribute(
        :bam,
        Class.new(Dry::Struct) do
          include(JsonModel::Schema)

          schema_id('https://example.com/schemas/bam.json')
          attribute(:bam, JsonModel::Types::String)
        end.external,
      )
      klass.attribute(
        :bar,
        JsonModel::Types::Array.of(
          JsonModel::Types::Array.of(
            Class.new(Dry::Struct) do
              include(JsonModel::Schema)

              attribute(:bar, JsonModel::Types::String)

              def self.name
                'Bar'
              end
            end.local,
          ),
        ),
      )

      expect(klass.as_schema)
        .to(
          eq(
            {
              type: 'object',
              properties: {
                bam: { '$ref': 'https://example.com/schemas/bam.json' },
                bar: {
                  type: 'array',
                  items: {
                    type: 'array',
                    items: { '$ref': '#/$defs/Bar' },
                  },
                },
                foo: {
                  type: 'object',
                  properties: { foo: { type: 'string' } },
                  required: %i(foo),
                },
              },
              '$defs': {
                Bar: {
                  type: 'object',
                  properties: { bar: { type: 'string' } },
                  required: %i(bar),
                },
              },
              required: %i(bam bar foo),
            },
          ),
        )
    end

    context('inheritance') do
      let(:child) do
        Class.new(klass) do
          schema_id('https://example.com/schemas/child.json')
          attribute(:baz, JsonModel::Types::String)
        end
      end
      let(:second_child) do
        Class.new(klass) do
          schema_id('https://example.com/schemas/second-child.json')
          title('SecondChild')
          attribute(:bar, JsonModel::Types::String)
        end
      end

      it('uses $ref for inherited schemas if they have a schema id') do
        klass.schema_id('https://example.com/schemas/example.json')
        klass.attribute(:foo, JsonModel::Types::String)

        expect(child.as_schema)
          .to(
            eq(
              {
                '$id': 'https://example.com/schemas/child.json',
                '$ref': 'https://example.com/schemas/example.json',
                type: 'object',
                properties: { baz: { type: 'string' } },
                required: %i(baz),
              },
            ),
          )

        expect(second_child.as_schema)
          .to(
            eq(
              {
                '$id': 'https://example.com/schemas/second-child.json',
                '$ref': 'https://example.com/schemas/example.json',
                title: 'SecondChild',
                type: 'object',
                properties: { bar: { type: 'string' } },
                required: %i(bar),
              },
            ),
          )

        instance = child.new(foo: 'foo', baz: 'baz')
        expect(instance.foo).to(eq('foo'))
        expect(instance.baz).to(eq('baz'))

        second_instance = second_child.new(foo: 'foo', bar: 'bar')
        expect(second_instance.foo).to(eq('foo'))
        expect(second_instance.bar).to(eq('bar'))
      end
    end
  end
end
