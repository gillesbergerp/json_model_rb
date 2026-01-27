# frozen_string_literal: true

require('spec_helper')

RSpec.describe('File system schema') do
  before do
    stub_const(
      'DiskDevice',
      Class.new(Dry::Struct) do
        include(JsonModel::Schema)

        def self.name
          'DiskDevice'
        end

        attribute(:type, JsonModel::Types::String.constrained(eql: 'disk'))
        attribute(:device, JsonModel::Types::String.constrained(format: %r{\A/dev/[^/]+(/[^/]+)*\z}))
      end,
    )

    stub_const(
      'DiskUuid',
      Class.new(Dry::Struct) do
        include(JsonModel::Schema)

        def self.name
          'DiskUuid'
        end

        attribute(:type, JsonModel::Types::String.enum('diskUUID', 'diskuuid'))
        attribute(
          :label,
          JsonModel::Types::String.constrained(
            format: /\A[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}\z/,
          ),
        )
      end,
    )

    stub_const(
      'Nfs',
      Class.new(Dry::Struct) do
        include(JsonModel::Schema)

        def self.name
          'Nfs'
        end

        attribute(:type, JsonModel::Types::String.constrained(eql: 'nfs'))
        attribute(:remote_path, JsonModel::Types::String.constrained(format: %r{\A(/[^/]+)+\z}).as(:remotePath))
        attribute(:server, JsonModel::Types::IPv4)
      end,
    )

    stub_const(
      'Tmpfs',
      Class.new(Dry::Struct) do
        include(JsonModel::Schema)

        def self.name
          'Tmpfs'
        end

        attribute(:type, JsonModel::Types::String.constrained(eql: 'tmpfs'))
        attribute(:size_in_mb, JsonModel::Types::Integer.constrained(gteq: 16, lteq: 512).as(:sizeInMB))
      end,
    )

    stub_const(
      'Fstab',
      Class.new(Dry::Struct) do
        include(JsonModel::Schema)

        description('JSON Schema for an fstab entry')
        attribute(
          :storage,
          JsonModel::Types.one_of(:type) do
            on('disk', DiskDevice.local)
            on('diskUUID', 'diskuuid', DiskUuid.local)
            on('nfs', Nfs.local)
            on('tmpfs', Tmpfs.local)
          end,
        )
        attribute(:fstype, JsonModel::Types::String.enum('ext3', 'ext4', 'btrfs'))
        attribute(
          :options,
          JsonModel::Types::Array.of(JsonModel::Types::String).constrained(min_size: 1, unique: true).optional,
        )
        attribute?(:readonly, JsonModel::Types::Bool.optional)
      end,
    )
  end

  it('renders the schema') do
    expect(Fstab.as_schema)
      .to(
        eq(
          {
            description: 'JSON Schema for an fstab entry',
            type: 'object',
            required: %i(fstype storage),
            properties: {
              storage: {
                oneOf: [
                  { '$ref': '#/$defs/DiskDevice' },
                  { '$ref': '#/$defs/DiskUuid' },
                  { '$ref': '#/$defs/Nfs' },
                  { '$ref': '#/$defs/Tmpfs' },
                ],
              },
              fstype: {
                enum: %w(ext3 ext4 btrfs),
              },
              options: {
                anyOf: [
                  { type: 'null' },
                  {
                    type: 'array',
                    minItems: 1,
                    items: {
                      type: 'string',
                    },
                    uniqueItems: true,
                  },
                ],
              },
              readonly: {
                anyOf: [
                  { type: 'null' },
                  { type: 'boolean' },
                ],
              },
            },
            '$defs': {
              DiskDevice: {
                properties: {
                  type: {
                    const: 'disk',
                    type: 'string',
                  },
                  device: {
                    type: 'string',
                    pattern: '\\A/dev/[^/]+(/[^/]+)*\\z',
                  },
                },
                required: %i(device type),
                type: 'object',
              },
              DiskUuid: {
                properties: {
                  type: { enum: %w(diskUUID diskuuid) },
                  label: {
                    type: 'string',
                    pattern: '\\A[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}\\z',
                  },
                },
                required: %i(label type),
                type: 'object',
              },
              Nfs: {
                properties: {
                  type: {
                    const: 'nfs',
                    type: 'string',
                  },
                  remotePath: {
                    type: 'string',
                    pattern: '\\A(/[^/]+)+\\z',
                  },
                  server: {
                    type: 'string',
                    format: 'ipv4',
                  },
                },
                required: %i(remotePath server type),
                type: 'object',
              },
              Tmpfs: {
                properties: {
                  type: {
                    const: 'tmpfs',
                    type: 'string',
                  },
                  sizeInMB: { type: 'integer', minimum: 16, maximum: 512 },
                },
                required: %i(sizeInMB type),
                type: 'object',
              },
            },
          },
        ),
      )
  end

  it('can instantiate a model') do
    instance = Fstab.new(
      storage: { device: '/dev/sda1', type: 'disk' },
      fstype: 'ext4',
      options: %w(rw noatime),
    )

    expect(instance.storage).to(be_a(DiskDevice))
    expect(instance.storage.device).to(eq('/dev/sda1'))
    expect(instance.fstype).to(eq('ext4'))
    expect(instance.options).to(eq(%w(rw noatime)))
    expect(instance.readonly).to(be_nil)
  end
end
