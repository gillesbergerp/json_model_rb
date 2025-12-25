# frozen_string_literal: true

require('spec_helper')

RSpec.describe(JsonModel::TypeSpec::Enum) do
  describe('#as_schema') do
    it('returns an enum schema') do
      expect(described_class.new(enum: [1, 'a']).as_schema)
        .to(
          eq(
            {
              enum: [1, 'a'],
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

    context('for nil values') do
      it('fails the validation if not allowed') do
        described_class
          .new(enum: [1])
          .register_validations(:foo, klass)
        instance = klass.new(foo: nil)

        expect(instance.valid?)
          .to(be(false))
        expect(instance.errors.map(&:type))
          .to(eq(%i(inclusion)))
      end

      it('succeeds the validation if allowed') do
        described_class
          .new(enum: [nil])
          .register_validations(:foo, klass)
        instance = klass.new(foo: nil)

        expect(instance.valid?)
          .to(be(true))
        expect(instance.errors)
          .to(be_empty)
      end
    end

    context('for non-nil values') do
      before do
        described_class
          .new(enum: [1, 'a'])
          .register_validations(:foo, klass)
      end

      it('fails the validation if nil') do
        instance = klass.new(foo: nil)

        expect(instance.valid?)
          .to(be(false))
        expect(instance.errors.map(&:type))
          .to(eq(%i(inclusion)))
      end

      it('fails the validation if not allowed') do
        instance = klass.new(foo: 0)

        expect(instance.valid?)
          .to(be(false))
        expect(instance.errors.map(&:type))
          .to(eq(%i(inclusion)))
      end

      it('succeeds the validation if allowed') do
        instance = klass.new(foo: 'a')

        expect(instance.valid?)
          .to(be(true))
        expect(instance.errors)
          .to(be_empty)
      end
    end
  end
end
