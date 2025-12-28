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

    it('raises if all of the types fail') do
      expect { subject.cast({ bam: 'bam' }) }
        .to(raise_error(JsonModel::Errors::TypeError))
    end

    it('raises if more than one type passes') do
      expect { subject.cast({ foo: 'foo', bar: 'bar' }) }
        .to(raise_error(JsonModel::Errors::TypeError))
    end

    it('returns the value if one type passes') do
      foo_instance = subject.cast({ foo: 'foo' })

      expect(foo_instance).to(be_instance_of(foo))
      expect(foo_instance.foo).to(eq('foo'))
    end
  end
end
