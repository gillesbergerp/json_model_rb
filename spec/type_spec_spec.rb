# frozen_string_literal: true

require('spec_helper')

RSpec.describe(JsonModel::TypeSpec) do
  describe('#resolve') do
    shared_examples_for('primitive type') do |type:, expected_type:|
      it("resolves to a primitive type spec for #{type}") do
        expect(JsonModel::TypeSpec.resolve(type))
          .to(be_a(expected_type))
      end
    end

    shared_examples_for('unsupported type') do |type|
      it("raises an error for #{type}") do
        expect { JsonModel::TypeSpec.resolve(type) }
          .to(raise_error(ArgumentError))
      end
    end

    it_behaves_like('primitive type', type: String, expected_type: JsonModel::TypeSpec::Primitive::String)
    it_behaves_like('primitive type', type: Integer, expected_type: JsonModel::TypeSpec::Primitive::Integer)
    it_behaves_like('primitive type', type: Float, expected_type: JsonModel::TypeSpec::Primitive::Number)
    it_behaves_like('primitive type', type: TrueClass, expected_type: JsonModel::TypeSpec::Primitive::Boolean)
    it_behaves_like('primitive type', type: FalseClass, expected_type: JsonModel::TypeSpec::Primitive::Boolean)
    it_behaves_like('primitive type', type: JsonModel::TypeSpec::Primitive::String.new, expected_type: JsonModel::TypeSpec::Primitive::String)

    it_behaves_like('unsupported type', Class.new)
    it_behaves_like('unsupported type', Object.new)
    it_behaves_like('unsupported type', nil)
  end
end
