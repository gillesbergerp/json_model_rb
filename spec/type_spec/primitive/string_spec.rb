# frozen_string_literal: true

require('spec_helper')

RSpec.describe(JsonModel::TypeSpec::Primitive::String) do
  describe('#as_schema') do
    it('returns a string schema') do
      expect(subject.as_schema)
        .to(eq({ type: 'string' }))
    end

    it('includes the minLength attribute') do
      expect(described_class.new(min_length: 10).as_schema)
        .to(eq({ type: 'string', minLength: 10 }))
    end

    it('includes the maxLength attribute') do
      expect(described_class.new(max_length: 10).as_schema)
        .to(eq({ type: 'string', maxLength: 10 }))
    end

    it('includes the pattern attribute') do
      expect(described_class.new(pattern: /\A\w+\z/).as_schema)
        .to(eq({ type: 'string', pattern: '\\A\\w+\\z' }))
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

    context('for min length') do
      before do
        described_class
          .new(min_length: 3)
          .register_validations(:foo, klass)
      end

      it('fails the validation for too short strings') do
        instance = klass.new(foo: 'ba')

        expect(instance.valid?)
          .to(be(false))
        expect(instance.errors.map(&:type))
          .to(eq(%i(too_short)))
      end

      it('succeeds the validation for valid strings') do
        instance = klass.new(foo: 'bar')

        expect(instance.valid?)
          .to(be(true))
        expect(instance.errors)
          .to(be_empty)
      end
    end

    context('for max length') do
      before do
        described_class
          .new(max_length: 2)
          .register_validations(:foo, klass)
      end

      it('fails the validation for too short strings') do
        instance = klass.new(foo: 'bar')

        expect(instance.valid?)
          .to(be(false))
        expect(instance.errors.map(&:type))
          .to(eq(%i(too_long)))
      end

      it('succeeds the validation for valid strings') do
        instance = klass.new(foo: 'ba')

        expect(instance.valid?)
          .to(be(true))
        expect(instance.errors)
          .to(be_empty)
      end
    end

    context('for a pattern') do
      before do
        described_class
          .new(pattern: /\A\w+\z/)
          .register_validations(:foo, klass)
      end

      it('fails the validation for an invalid value') do
        instance = klass.new(foo: ' bar')

        expect(instance.valid?)
          .to(be(false))
        expect(instance.errors.map(&:type))
          .to(eq(%i(invalid)))
      end

      it('succeeds the validation for valid strings') do
        instance = klass.new(foo: 'bar')

        expect(instance.valid?)
          .to(be(true))
        expect(instance.errors)
          .to(be_empty)
      end
    end
  end
end
