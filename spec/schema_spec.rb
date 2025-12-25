# frozen_string_literal: true

require('spec_helper')

RSpec.describe(JsonModel::Schema) do
  describe('.initialize') do
    let(:klass) do
      Class.new do
        include(JsonModel::Schema)
        property(:foo, type: String)
      end
    end

    it('succeeds without providing attributes') do
      expect { klass.new }.not_to(raise_error)
    end

    it('sets attribute values') do
      instance = klass.new(foo: 'bar')

      expect(instance.foo)
        .to(eq('bar'))
    end

    it('raises an error for unknown attributes') do
      expect { klass.new(bar: 'baz') }
        .to(raise_error(JsonModel::Errors::UnknownAttributeError))
    end
  end

  describe('#valid?') do
    let(:klass) do
      Class.new do
        include(JsonModel::Schema)
        property(:foo, type: String, min_length: 3)
      end
    end

    it('returns false for invalid values') do
      expect(klass.new(foo: 'ba').valid?)
        .to(be(false))
    end

    it('returns true for valid values') do
      expect(klass.new(foo: 'bar').valid?)
        .to(be(true))
    end
  end
end
