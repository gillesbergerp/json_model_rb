# frozen_string_literal: true

require('spec_helper')

RSpec.describe('File system schema') do
  before do
    stub_const(
      'DiskDevice',
      Class.new do
        include(JsonModel::Schema)

        property(:type, type: JsonModel::Types.const('disk'))
        property(:device, type: JsonModel::Types.string.pattern(%r{\A/dev/[^/]+(/[^/]+)*\z}))
      end,
    )

    stub_const(
      'DiskUuid',
      Class.new do
        include(JsonModel::Schema)

        property(:type, type: JsonModel::Types.enum('diskUUID', 'diskuuid'))
        property(
          :label,
          type: JsonModel::Types.string.pattern(/\A[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}\z/),
        )
      end,
    )

    stub_const(
      'Nfs',
      Class.new do
        include(JsonModel::Schema)

        property(:type, type: JsonModel::Types.const('nfs'))
        property(:remote_path, type: JsonModel::Types.string.pattern(%r{\A(/[^/]+)+\z}), as: :remotePath)
        property(:server, type: JsonModel::Types.string.format(:ipv4))
      end,
    )

    stub_const(
      'Tmpfs',
      Class.new do
        include(JsonModel::Schema)

        property(:type, type: JsonModel::Types.const('tmpfs'))
        property(:size_in_mb, type: JsonModel::Types.integer.minimum(16).maximum(512), as: :sizeInMB)
      end,
    )

    stub_const(
      'Fstab',
      Class.new do
        include(JsonModel::Schema)

        description('JSON Schema for an fstab entry')
        property(
          :storage,
          type: JsonModel::Types.one_of(DiskDevice, DiskUuid, Nfs, Tmpfs, discriminator: :type),
          ref_mode: JsonModel::RefMode::LOCAL,
        )
        property(:fstype, type: JsonModel::Types.enum('ext3', 'ext4', 'btrfs'), optional: true)
        property(:options, type: JsonModel::Types.array(String).min_items(1).unique_items, optional: true)
        property(:readonly, type: JsonModel::Types.boolean, optional: true)
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
            required: %i(storage),
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
                type: 'array',
                minItems: 1,
                items: {
                  type: 'string',
                },
                uniqueItems: true,
              },
              readonly: {
                type: 'boolean',
              },
            },
            '$defs': {
              DiskDevice: {
                properties: {
                  type: {
                    const: 'disk',
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
                  type: { const: 'nfs' },
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
                  type: { const: 'tmpfs' },
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
