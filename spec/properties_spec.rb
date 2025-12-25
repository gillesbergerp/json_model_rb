# frozen_string_literal: true

# frozen_string_literal:
require('spec_helper')

RSpec.describe(JsonModel::Properties) do
  describe('.property') do
    let(:klass) do
      Class.new do
        include(JsonModel::Properties)
      end
    end

    it('has no default properties') do
      expect(klass.properties)
        .to(eq({}))
    end

    it('adds a property by name') do
      klass.property(:foo, type: String)

      expect(klass.properties.keys)
        .to(eq(%i(foo)))
      expect(klass.properties[:foo])
        .to(be_a(JsonModel::Property))
    end
  end

  describe('.as_schema') do
    let(:klass) do
      Class.new do
        include(JsonModel::Properties)
      end
    end

    it('returns an empty hash of properties') do
      expect(klass.as_schema)
        .to(eq({ properties: {} }))
    end

    it('returns properties as schema') do
      klass.property(:foo, type: String)
      klass.property(:bar, type: Float)

      expect(klass.as_schema)
        .to(
          eq(
            {
              properties: {
                bar: { type: 'number' },
                foo: { type: 'string' },
              },
            },
          ),
        )
    end
  end

  describe('getter and setter') do
    let(:klass) do
      Class.new do
        include(JsonModel::Properties)
        property(:foo, type: String)
      end
    end

    it('responds to the getter') do
      expect(klass.new)
        .to(respond_to(:foo))
    end

    it('responds to the setter') do
      expect(klass.new)
        .to(respond_to(:foo=))
    end

    it('allows updating the property') do
      instance = klass.new

      expect(instance.foo)
        .to(be_nil)

      instance.foo = 'bar'

      expect(instance.foo)
        .to(eq('bar'))
    end
  end
end
