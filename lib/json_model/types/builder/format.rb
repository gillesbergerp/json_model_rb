# frozen_string_literal: true

module JsonModel
  module Types
    module Builder
      module Format
        extend(ActiveSupport::Concern)
        include(Builder)

        included do
          register_constraint(:format, Constraint)
        end

        class Constraint
          JSON_SCHEMA_FORMATS = {
            date_time: lambda { |v|
              begin
                DateTime.iso8601(v)
                true
              rescue StandardError
                false
              end
            },
            date: lambda { |v|
              begin
                Date.iso8601(v)
                true
              rescue StandardError
                false
              end
            },
            time: lambda { |v|
              begin
                Time.iso8601(v)
                true
              rescue StandardError
                false
              end
            },
            email: ->(v) { v.match?(URI::MailTo::EMAIL_REGEXP) },
            hostname: ->(v) { v.match?(/\A[a-zA-Z0-9\-.]{1,253}\z/) },
            ipv4: lambda { |v|
              begin
                IPAddr.new(v).ipv4?
              rescue StandardError
                false
              end
            },
            ipv6: lambda { |v|
              begin
                IPAddr.new(v).ipv6?
              rescue StandardError
                false
              end
            },
            uri: lambda { |v|
              begin
                URI.parse(v)
                true
              rescue StandardError
                false
              end
            },
            uri_reference: lambda { |v|
              begin
                URI.parse(v)
                true
              rescue StandardError
                false
              end
            },
            uuid: lambda { |v|
              v.match?(/\A[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/i)
            },
            regex: lambda { |v|
              begin
                Regexp.new(v)
                true
              rescue StandardError
                false
              end
            },
            json_pointer: ->(v) { v.match?(%r{\A(?:/(?:[^~]|~[01])*)*\z}) },
            relative_json_pointer: ->(v) { v.match?(%r{\A(?:0|[1-9][0-9]*)(?:#|(?:/(?:[^~]|~[01])*))*\z}) },
          }.freeze

          # @param [String] format
          def initialize(format)
            @format = format
          end

          # @param [Hash] _options
          # @return [Hash]
          def as_schema(**_options)
            { format: @format&.to_s&.tr('_', '-') }
          end

          # @param [Symbol] name
          # @param [ActiveModel::Validations] klass
          def register_validations(name, klass)
            if !JSON_SCHEMA_FORMATS.key?(@format)
              raise(ArgumentError, "Invalid format: #{@format}")
            end

            format_validator = JSON_SCHEMA_FORMATS[@format]
            klass.validate do |record|
              value = record.send(name)

              if !value.nil? && !format_validator.call(value)
                record.errors.add(name, :invalid_format, message: "must be a valid #{@format}")
              end
            end
          end
        end
      end
    end
  end
end
