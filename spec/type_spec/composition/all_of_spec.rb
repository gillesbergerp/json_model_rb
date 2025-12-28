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

  describe('#cast') do
    let(:foo) do
      Class.new do
        include(JsonModel::Schema)

        additional_properties(true)
        property(:foo, type: String)
      end
    end

    let(:bar) do
      Class.new do
        include(JsonModel::Schema)

        additional_properties(true)
        property(:bar, type: String)
      end
    end

    subject { described_class.new(JsonModel::TypeSpec::Object.new(foo), JsonModel::TypeSpec::Object.new(bar)) }

    it('raises if one of the types fails') do
      expect { subject.cast({ foo: 'foo' }) }
        .to(raise_error(JsonModel::Errors::TypeError))
    end

    it('returns the value if all types pass') do
      foo_instance, bar_instance = subject.cast({ foo: 'foo', bar: 'bar' })

      expect(foo_instance).to(be_instance_of(foo))
      expect(foo_instance.foo).to(eq('foo'))

      expect(bar_instance).to(be_instance_of(bar))
      expect(bar_instance.bar).to(eq('bar'))
    end
  end
end
