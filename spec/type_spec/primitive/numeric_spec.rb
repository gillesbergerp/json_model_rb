# frozen_string_literal: true

require('spec_helper')

RSpec.describe(JsonModel::TypeSpec::Primitive::Numeric) do
  describe('#as_schema') do
    it('includes the multipleOf attribute') do
      expect(described_class.new('number', multiple_of: 5).as_schema)
        .to(eq({ type: 'number', multipleOf: 5 }))
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

    context('for multiple of') do
      before do
        described_class
          .new('number', multiple_of: 5)
          .register_validations(:foo, klass)
      end

      it('fails the validation for non-multiples') do
        instance = klass.new(foo: 1234)

        expect(instance.valid?)
          .to(be(false))
        expect(instance.errors.map(&:type))
          .to(eq(['must be a multiple of 5']))
      end

      it('succeeds the validation for integers') do
        instance = klass.new(foo: 12_345)

        expect(instance.valid?)
          .to(be(true))
        expect(instance.errors)
          .to(be_empty)
      end
    end
  end
end
