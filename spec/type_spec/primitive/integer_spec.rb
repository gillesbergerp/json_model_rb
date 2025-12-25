# frozen_string_literal: true

require('spec_helper')

RSpec.describe(JsonModel::TypeSpec::Primitive::Integer) do
  describe('#as_schema') do
    it('returns an integer schema') do
      expect(subject.as_schema)
        .to(eq({ type: 'integer' }))
    end
  end

  describe('.register_validations') do
    let(:klass) do
      Class.new do
        include(ActiveModel::Validations)
        attr_accessor(:foo)

        def initialize(foo:)
          @foo = foo
        end
      end
    end

    context('for integer-ness') do
      before do
        described_class
          .new
          .register_validations(:foo, klass)
      end

      it('fails the validation for floats') do
        instance = klass.new(foo: 1.234)

        expect(instance.valid?)
          .to(be(false))
        expect(instance.errors.map(&:type))
          .to(eq(%i(not_an_integer)))
      end

      it('succeeds the validation for integers') do
        instance = klass.new(foo: 1234)

        expect(instance.valid?)
          .to(be(true))
        expect(instance.errors)
          .to(be_empty)
      end
    end
  end
end
