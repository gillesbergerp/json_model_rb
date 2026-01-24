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
      property(:state, type: JsonModel::Types.string.optional)
      property(:postal_code, type: JsonModel::Types.string.pattern(/\A\d{5}(-\d{4})?\z/).optional)
      property(:country, type: JsonModel::Types.string.with_default('USA'))
    end

    stub_const('Address', address_class)

    user_class = Class.new do
      include(JsonModel::Schema)

      def self.name
        'User'
      end

      property(:name, type: String)
      property(:email, type: JsonModel::Types.string.format(:email))
      property(:age, type: JsonModel::Types.integer.minimum(0).maximum(120).optional)
      property(:active, type: JsonModel::Types.boolean.optional.with_default(true))
      property(:addresses, type: JsonModel::Types.array(JsonModel::Types.object(Address).with_ref_mode(JsonModel::RefMode::LOCAL)))
      property(:tags, type: JsonModel::Types.array(String).optional)
      property(:birthday, type: JsonModel::Types.date.optional)
      property(:websites, type: JsonModel::Types.array(URI).optional)
      property(:height, type: JsonModel::Types.number.optional)
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
              birthday: { type: 'string', format: 'date' },
              websites: { type: 'array', items: { type: 'string', format: 'uri' } },
              height: { type: 'number' },
            },
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
      birthday: '2000-01-01',
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
