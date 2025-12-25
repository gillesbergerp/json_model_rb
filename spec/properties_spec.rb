# frozen_string_literal:
require('spec_helper')

RSpec.describe(JsonModel::Properties) do
  describe('.property') do
    let(:klass) do
      Class.new do
        include(JsonModel::Properties)
      end
    end

    it('has no default properties') do
      expect(klass.properties)
        .to(eq({}))
    end

    it('adds a property by name') do
      klass.property(:foo)

      expect(klass.properties.keys)
        .to(eq(%i(foo)))
      expect(klass.properties[:foo])
        .to(be_a(JsonModel::Property))
    end
  end
end
