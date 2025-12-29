# frozen_string_literal: true

require('spec_helper')

RSpec.describe(JsonModel::TypeSpec::Const) do
  describe('#as_schema') do
    it('returns a const schema') do
      expect(described_class.new('a').as_schema)
        .to(
          eq(
            {
              const: 'a'
            },
          ),
        )
    end
  end
end
