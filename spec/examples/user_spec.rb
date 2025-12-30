# frozen_string_literal: true

require('spec_helper')

RSpec.describe('User schema') do
  before do
    address_class = Class.new do
      include(JsonModel::Schema)

      def self.name
        'Address'
      end

      property(:street, type: String)
      property(:city, type: String)
      property(:state, type: String, optional: true)
      property(:postal_code, type: T::String[pattern: /\A\d{5}(-\d{4})?\z/], optional: true)
      property(:country, type: String, default: 'USA')
    end

    stub_const('Address', address_class)

    user_class = Class.new do
      include(JsonModel::Schema)

      def self.name
        'User'
      end

      property(:name, type: String)
      property(:email, type: T::String[format: :email])
      property(:age, type: T::Integer[minimum: 0, maximum: 120], optional: true)
      property(:active, type: T::Boolean, default: true, optional: true)
      property(:addresses, type: T::Array[Address], ref_mode: JsonModel::RefMode::LOCAL)
      property(:tags, type: T::Array[String], optional: true)
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
              name: { type: 'string' },
              email: { type: 'string', format: 'email' },
              age: { type: 'integer', minimum: 0, maximum: 120 },
              active: { type: 'boolean', default: true },
              addresses: {
                type: 'array',
                items: { '$ref': '#/$defs/Address' },
              },
              tags: { type: 'array', items: { type: 'string' } },
            },
            additionalProperties: false,
            required: %i(addresses email name),
            '$defs': {
              Address: {
                type: 'object',
                properties: {
                  city: { type: 'string' },
                  country: { type: 'string', default: 'USA' },
                  postal_code: { type: 'string', pattern: '\A\d{5}(-\d{4})?\z' },
                  state: { type: 'string' },
                  street: { type: 'string' },
                },
                required: %i(city country street),
                additionalProperties: false,
              },
            },
          },
        ),
      )
  end

  it('can instantiate a model') do
    user = User.new(name: 'Foo', email: 'foo@example.com', addresses: [{ street: '123 Main St', city: 'Anytown' }])

    expect(user.name).to(eq('Foo'))
    expect(user.email).to(eq('foo@example.com'))
    expect(user.active).to(eq(true))
    expect(user.age).to(be_nil)
    expect(user.addresses.first.street).to(eq('123 Main St'))
    expect(user.addresses.first.country).to(eq('USA'))
    expect(user.addresses.first.postal_code).to(be_nil)
    expect(user.addresses.first.state).to(be_nil)
    expect(user.addresses.first.city).to(eq('Anytown'))
  end
end
