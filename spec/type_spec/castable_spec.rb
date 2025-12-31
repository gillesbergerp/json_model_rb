# frozen_string_literal: true

require('spec_helper')

RSpec.describe(JsonModel::TypeSpec::Castable) do
  describe('#as_schema') do
    it('returns a string schema') do
      expect(described_class.new(format: 'date') { |v| v }.as_schema)
        .to(eq({ type: 'string', format: 'date' }))
    end
  end

  describe('#cast') do
    it('casts a string') do
      expect(described_class.new(format: 'date') { |v| Date.parse(v) }.cast('2020-01-01'))
        .to(eq(Date.new(2020, 1, 1)))
    end
  end
end
