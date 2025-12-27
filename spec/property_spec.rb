# frozen_string_literal: true

require('spec_helper')

RSpec.describe(JsonModel::Property) do
  describe('.register_validations') do
    let(:klass) do
      Class.new do
        include(ActiveModel::Validations)

        attr_accessor(:foo)
      end
    end

    context('for an optional property') do
      before do
        described_class
          .new(:foo, type: JsonModel::TypeSpec::Primitive::String.new, optional: true)
          .register_validations(klass)
      end

      it('does not fail the validation for missing values') do
        instance = klass.new

        expect(instance.valid?)
          .to(be(true))
        expect(instance.errors)
          .to(be_empty)
      end

      it('does not fail the validation for present values') do
        instance = klass.new.tap { |obj| obj.foo = 'bar' }

        expect(instance.valid?)
          .to(be(true))
        expect(instance.errors)
          .to(be_empty)
      end
    end

    context('for a non-optional property') do
      before do
        described_class
          .new(:foo, type: JsonModel::TypeSpec::Primitive::String.new)
          .register_validations(klass)
      end

      it('fails the validation for missing values') do
        instance = klass.new

        expect(instance.valid?)
          .to(be(false))
        expect(instance.errors.map(&:type))
          .to(eq(%i(blank)))
      end

      it('does not fail the validation for present values') do
        instance = klass.new.tap { |obj| obj.foo = 'bar' }

        expect(instance.valid?)
          .to(be(true))
        expect(instance.errors)
          .to(be_empty)
      end
    end
  end

  describe('#as_schema') do
    it('renders the property as a schema') do
      expect(described_class.new(:foo, type: JsonModel::TypeSpec::Primitive::String.new).as_schema)
        .to(eq({ foo: { type: 'string' } }))
    end

    it('respects the "as" option') do
      expect(described_class.new(:foo, type: JsonModel::TypeSpec::Primitive::String.new, as: :bar).as_schema)
        .to(eq({ bar: { type: 'string' } }))
    end

    it('falls back to the configured naming strategy') do
      JsonModel.configure { |config| config.property_naming_strategy = :camel_case }

      expect(described_class.new(:foo_bar, type: JsonModel::TypeSpec::Primitive::String.new).as_schema)
        .to(eq({ fooBar: { type: 'string' } }))
    end
  end
end
