# frozen_string_literal: true

RSpec.describe(JsonModel) do
  it('has a version number') do
    expect(JsonModel::VERSION).not_to(be(nil))
  end
end
