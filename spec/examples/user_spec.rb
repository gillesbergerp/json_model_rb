# frozen_string_literal: true

require('spec_helper')

RSpec.describe('User schema') do
  before do
    address_class = Class.new(Dry::Struct) do
      include(JsonModel::Schema)

      def self.name
        'Address'
      end

      attribute(:street, JsonModel::Types::String)
      attribute(:city, JsonModel::Types::String)
      attribute?(:state, JsonModel::Types::String.optional)
      attribute?(:postal_code, JsonModel::Types::String.constrained(format: /\A\d{5}(-\d{4})?\z/).optional)
      attribute(:country, JsonModel::Types::String.default('USA'))
    end

    stub_const('Address', address_class)

    user_class = Class.new(Dry::Struct) do
      include(JsonModel::Schema)

      def self.name
        'User'
      end

      attribute(:name, JsonModel::Types::String.constrained(min_size: 3))
      attribute(:email, JsonModel::Types::Email)
      attribute?(:age, JsonModel::Types::Integer.constrained(gteq: 0, lteq: 120).optional)
      attribute(:active, JsonModel::Types::Bool.optional.default(true))
      attribute(:addresses, JsonModel::Types::Array.of(Address.local))
      attribute?(:tags, JsonModel::Types::Array.of(JsonModel::Types::String).optional)
      attribute(:birthday, JsonModel::Types::Date.optional)
      attribute?(:websites, JsonModel::Types::Array.of(JsonModel::Types::URI).optional)
      attribute?(:height, JsonModel::Types::Float.optional)
    end

    stub_const('User', user_class)
  end

  it('renders the schema') do
    expect(User.as_schema)
      .to(
        eq(
          {
            type: 'object',
            properties: {
              name: { type: 'string', minLength: 3 },
              email: { type: 'string', format: 'email' },
              age: {
                anyOf: [
                  { type: 'null' },
                  { type: 'integer', minimum: 0, maximum: 120 },
                ],
              },
              active: {
                anyOf: [
                  { type: 'null' },
                  { type: 'boolean' },
                ],
                default: true,
              },
              addresses: {
                type: 'array',
                items: { '$ref': '#/$defs/Address' },
              },
              tags: {
                anyOf: [
                  { type: 'null' },
                  { type: 'array', items: { type: 'string' } },
                ],
              },
              birthday: {
                anyOf: [
                  { type: 'null' },
                  { type: 'string', format: 'date' },
                ],
              },
              websites: {
                anyOf: [
                  { type: 'null' },
                  { type: 'array', items: { type: 'string', format: 'uri' } },
                ],
              },
              height: {
                anyOf: [
                  { type: 'null' },
                  { type: 'number' },
                ],
              },
            },
            required: %i(addresses email name),
            '$defs': {
              Address: {
                type: 'object',
                properties: {
                  city: { type: 'string' },
                  country: { type: 'string', default: 'USA' },
                  postal_code: {
                    anyOf: [
                      { type: 'null' },
                      { type: 'string', pattern: '\A\d{5}(-\d{4})?\z' },
                    ],
                  },
                  state: {
                    anyOf: [
                      { type: 'null' },
                      { type: 'string' },
                    ],
                  },
                  street: { type: 'string' },
                },
                required: %i(city country street),
              },
            },
          },
        ),
      )
  end

  it('can instantiate a model') do
    user = User.new(
      name: 'Foo',
      email: 'foo@example.com',
      addresses: [{ street: '123 Main St', city: 'Anytown' }],
      birthday: Date.new(2000, 1, 1),
    )

    expect(user.name).to(eq('Foo'))
    expect(user.email).to(eq('foo@example.com'))
    expect(user.active).to(eq(true))
    expect(user.age).to(be_nil)
    expect(user.addresses.first.street).to(eq('123 Main St'))
    expect(user.addresses.first.country).to(eq('USA'))
    expect(user.addresses.first.postal_code).to(be_nil)
    expect(user.addresses.first.state).to(be_nil)
    expect(user.addresses.first.city).to(eq('Anytown'))
    expect(user.birthday).to(eq(Date.new(2000, 1, 1)))
  end
end
