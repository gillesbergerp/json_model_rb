# frozen_string_literal: true

require('spec_helper')

RSpec.describe(JsonModel::TypeSpec::Array) do
  describe('#as_schema') do
    it('returns an array schema of primitive types') do
      expect(
        described_class.new(JsonModel::TypeSpec::Primitive::String.new).as_schema,
      )
        .to(
          eq(
            {
              type: 'array',
              items: { type: 'string' },
            },
          ),
        )
    end

    it('returns an array schema of nested array types') do
      expect(
        described_class.new(described_class.new(JsonModel::TypeSpec::Primitive::String.new)).as_schema,
      )
        .to(
          eq(
            {
              type: 'array',
              items: { type: 'array', items: { type: 'string' } },
            },
          ),
        )
    end

    it('includes the minItems attribute') do
      expect(
        described_class.new(JsonModel::TypeSpec::Primitive::String.new, min_items: 10).as_schema,
      )
        .to(
          eq(
            {
              type: 'array',
              items: { type: 'string' },
              minItems: 10,
            },
          ),
        )
    end

    it('includes the maxItems attribute') do
      expect(
        described_class.new(JsonModel::TypeSpec::Primitive::String.new, max_items: 10).as_schema,
      )
        .to(
          eq(
            {
              type: 'array',
              items: { type: 'string' },
              maxItems: 10,
            },
          ),
        )
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

    context('for min items') do
      before do
        described_class
          .new(JsonModel::TypeSpec::Primitive::String.new, min_items: 5)
          .register_validations(:foo, klass)
      end

      it('fails the validation for invalid values') do
        instance = klass.new(foo: ['a'] * 4)

        expect(instance.valid?)
          .to(be(false))
        expect(instance.errors.map(&:type))
          .to(eq(%i(too_short)))
      end

      it('succeeds the validation for valid values') do
        instance = klass.new(foo: ['a'] * 5)

        expect(instance.valid?)
          .to(be(true))
        expect(instance.errors)
          .to(be_empty)
      end
    end

    context('for max items') do
      before do
        described_class
          .new(JsonModel::TypeSpec::Primitive::String.new, max_items: 5)
          .register_validations(:foo, klass)
      end

      it('fails the validation for invalid values') do
        instance = klass.new(foo: ['a'] * 6)

        expect(instance.valid?)
          .to(be(false))
        expect(instance.errors.map(&:type))
          .to(eq(%i(too_long)))
      end

      it('succeeds the validation for valid values') do
        instance = klass.new(foo: ['a'] * 5)

        expect(instance.valid?)
          .to(be(true))
        expect(instance.errors)
          .to(be_empty)
      end
    end

    context('for unique items') do
      before do
        described_class
          .new(JsonModel::TypeSpec::Primitive::String.new, unique_items: true)
          .register_validations(:foo, klass)
      end

      it('fails the validation for invalid values') do
        instance = klass.new(foo: %w(a b a))

        expect(instance.valid?)
          .to(be(false))
        expect(instance.errors.map(&:type))
          .to(eq(%i(uniqueness)))
      end

      it('succeeds the validation for valid values') do
        instance = klass.new(foo: %w(a b c))

        expect(instance.valid?)
          .to(be(true))
        expect(instance.errors)
          .to(be_empty)
      end
    end
  end
end
