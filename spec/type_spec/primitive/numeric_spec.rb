# frozen_string_literal: true

require('spec_helper')

RSpec.describe(JsonModel::TypeSpec::Primitive::Numeric) do
  describe('#as_schema') do
    it('includes the multipleOf attribute') do
      expect(described_class.new('number', multiple_of: 5).as_schema)
        .to(eq({ type: 'number', multipleOf: 5 }))
    end

    it('includes the minimum attribute') do
      expect(described_class.new('number', minimum: 5).as_schema)
        .to(eq({ type: 'number', minimum: 5 }))
    end

    it('includes the maximum attribute') do
      expect(described_class.new('number', maximum: 5).as_schema)
        .to(eq({ type: 'number', maximum: 5 }))
    end

    it('includes the exclusiveMinimum attribute') do
      expect(described_class.new('number', exclusive_minimum: 5).as_schema)
        .to(eq({ type: 'number', exclusiveMinimum: 5 }))
    end

    it('includes the exclusiveMaximum attribute') do
      expect(described_class.new('number', exclusive_maximum: 5).as_schema)
        .to(eq({ type: 'number', exclusiveMaximum: 5 }))
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
          .to(eq(%i(multiple_of)))
      end

      it('succeeds the validation for integers') do
        instance = klass.new(foo: 12_345)

        expect(instance.valid?)
          .to(be(true))
        expect(instance.errors)
          .to(be_empty)
      end
    end

    context('for minimum') do
      before do
        described_class
          .new('number', minimum: 5)
          .register_validations(:foo, klass)
      end

      it('fails the validation for invalid values') do
        instance = klass.new(foo: 4)

        expect(instance.valid?)
          .to(be(false))
        expect(instance.errors.map(&:type))
          .to(eq(%i(greater_than_or_equal_to)))
      end

      it('succeeds the validation for valid values') do
        instance = klass.new(foo: 5)

        expect(instance.valid?)
          .to(be(true))
        expect(instance.errors)
          .to(be_empty)
      end
    end

    context('for maximum') do
      before do
        described_class
          .new('number', maximum: 5)
          .register_validations(:foo, klass)
      end

      it('fails the validation for invalid values') do
        instance = klass.new(foo: 6)

        expect(instance.valid?)
          .to(be(false))
        expect(instance.errors.map(&:type))
          .to(eq(%i(less_than_or_equal_to)))
      end

      it('succeeds the validation for valid values') do
        instance = klass.new(foo: 5)

        expect(instance.valid?)
          .to(be(true))
        expect(instance.errors)
          .to(be_empty)
      end
    end

    context('for exclusive_minimum') do
      before do
        described_class
          .new('number', exclusive_minimum: 5)
          .register_validations(:foo, klass)
      end

      it('fails the validation for invalid values') do
        instance = klass.new(foo: 5)

        expect(instance.valid?)
          .to(be(false))
        expect(instance.errors.map(&:type))
          .to(eq(%i(greater_than)))
      end

      it('succeeds the validation for valid values') do
        instance = klass.new(foo: 6)

        expect(instance.valid?)
          .to(be(true))
        expect(instance.errors)
          .to(be_empty)
      end
    end

    context('for exclusive_maximum') do
      before do
        described_class
          .new('number', exclusive_maximum: 5)
          .register_validations(:foo, klass)
      end

      it('fails the validation for invalid values') do
        instance = klass.new(foo: 5)

        expect(instance.valid?)
          .to(be(false))
        expect(instance.errors.map(&:type))
          .to(eq(%i(less_than)))
      end

      it('succeeds the validation for valid values') do
        instance = klass.new(foo: 4)

        expect(instance.valid?)
          .to(be(true))
        expect(instance.errors)
          .to(be_empty)
      end
    end
  end
end
