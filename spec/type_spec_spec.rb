# frozen_string_literal:
require('spec_helper')

RSpec.describe(JsonModel::TypeSpec) do
  describe('#resolve') do
    shared_examples_for('primitive type') do |type|
      it("resolves to a primitive type spec for #{type}") do
        expect(JsonModel::TypeSpec.resolve(type))
          .to(be_a(JsonModel::TypeSpec::Primitive))
      end
    end

    shared_examples_for('unsupported type') do |type|
      it("raises an error for #{type}") do
        expect { JsonModel::TypeSpec.resolve(type) }
          .to(raise_error(ArgumentError))
      end
    end

    it_behaves_like('primitive type', String)
    it_behaves_like('primitive type', Integer)
    it_behaves_like('primitive type', Float)
    it_behaves_like('primitive type', TrueClass)
    it_behaves_like('primitive type', FalseClass)
    it_behaves_like('primitive type', JsonModel::TypeSpec::Primitive.new(type: String))

    it_behaves_like('unsupported type', Class.new)
    it_behaves_like('unsupported type', Object.new)
    it_behaves_like('unsupported type', nil)
  end
end
