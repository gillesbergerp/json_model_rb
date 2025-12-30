# frozen_string_literal: true

require('spec_helper')

RSpec.describe(JsonModel::Schema) do
  describe('.initialize') do
    let(:klass) do
      Class.new do
        include(JsonModel::Schema)

        property(:foo, type: String, optional: true)

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
      expect { klass.new(bar: 'baz') }
        .to(raise_error(JsonModel::Errors::UnknownAttributeError))
    end

    it('does not raise an error for unknown attributes when additional properties are allowed') do
      klass.additional_properties(true)

      klass.new(bar: 'baz')
    end
  end

  describe('#valid?') do
    let(:klass) do
      Class.new do
        include(JsonModel::Schema)

        property(:foo, type: String, min_length: 3)
      end
    end

    before do
      JsonModel.configure { |config| config.validate_after_instantiation = false }
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

  describe('.from_json') do
    let(:klass) do
      Class.new do
        include(JsonModel::Schema)

        property(:foo_bar, type: String, as: :fooBar)
      end
    end

    it('can be instantiated from json') do
      instance = klass.from_json({ fooBar: 'baz' })
      expect(instance.foo_bar).to(eq('baz'))
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
        .to(eq({ type: 'object', additionalProperties: false }))
    end

    it('includes the schema id') do
      klass.schema_id('https://example.com/schemas/example.json')

      expect(klass.as_schema)
        .to(
          eq(
            {
              '$id': 'https://example.com/schemas/example.json',
              type: 'object',
              additionalProperties: false,
            },
          ),
        )
    end

    it('returns properties as schema') do
      klass.schema_id('https://example.com/schemas/example.json')
      klass.property(:foo, type: String)
      klass.property(:bar, type: Float, optional: true)
      klass.property(:baz, type: T::Enum[1, 'a', nil])
      klass.property(:bam, type: T::Array[T::AllOf[String, Float]])
      klass.property(:bal, type: klass, ref_mode: JsonModel::RefMode::EXTERNAL, optional: true)

      expect(klass.as_schema)
        .to(
          eq(
            {
              '$id': 'https://example.com/schemas/example.json',
              type: 'object',
              properties: {
                bal: { '$ref': 'https://example.com/schemas/example.json' },
                bam: {
                  type: 'array',
                  items: {
                    allOf: [{ type: 'string' }, { type: 'number' }],
                  },
                },
                bar: { type: 'number' },
                baz: { enum: [1, 'a', nil] },
                foo: { type: 'string' },
              },
              required: %i(bam baz foo),
              additionalProperties: false,
            },
          ),
        )
    end

    it('collects local references in $defs') do
      klass.property(
        :foo,
        type: Class.new do
          include(JsonModel::Schema)

          property(:foo, type: String)
        end,
      )
      klass.property(
        :bam,
        type: Class.new do
          include(JsonModel::Schema)

          property(:bam, type: String)
          schema_id('https://example.com/schemas/bam.json')
        end,
        ref_mode: JsonModel::RefMode::EXTERNAL,
      )
      klass.property(
        :bar,
        type: T::Array[
          T::Array[
            Class.new do
              include(JsonModel::Schema)

              property(:bar, type: String)

              def self.name
                'Bar'
              end
            end,
          ],
        ],
        ref_mode: JsonModel::RefMode::LOCAL,
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
                  additionalProperties: false,
                },
              },
              additionalProperties: false,
              '$defs': {
                Bar: {
                  type: 'object',
                  properties: { bar: { type: 'string' } },
                  required: %i(bar),
                  additionalProperties: false,
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
          property(:baz, type: String)
        end
      end
      let(:second_child) do
        Class.new(klass) do
          schema_id('https://example.com/schemas/second-child.json')
          title('SecondChild')
          property(:bar, type: String)
        end
      end

      it('uses $ref for inherited schemas if they have a schema id') do
        klass.schema_id('https://example.com/schemas/example.json')
        klass.property(:foo, type: String)

        expect(child.as_schema)
          .to(
            eq(
              {
                '$id': 'https://example.com/schemas/child.json',
                '$ref': 'https://example.com/schemas/example.json',
                type: 'object',
                additionalProperties: false,
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
                additionalProperties: false,
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
