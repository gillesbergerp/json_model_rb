# frozen_string_literal: true

module JsonModel
  class TypeSpec
    class Primitive
      class String < Primitive
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
            SecureRandom(v.match?(/\A[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/i))
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


        # @param [Integer, nil] min_length
        # @param [Integer, nil] max_length
        # @param [Regexp, nil] pattern
        # @param [String, nil] format
        def initialize(min_length: nil, max_length: nil, pattern: nil, format: nil)
          super('string')

          @min_length = min_length
          @max_length = max_length
          @pattern = pattern
          @format = format
        end

        # @param [Hash] options
        # @return [Hash]
        def as_schema(**options)
          super.merge(
            {
              minLength: @min_length,
              maxLength: @max_length,
              pattern: @pattern&.source,
              format: @format&.to_s&.tr('_', '-'),
            }.compact,
          )
        end

        # @param [Symbol] name
        # @param [ActiveModel::Validations]
        def register_validations(name, klass)
          super

          if !@min_length.nil? || !@max_length.nil?
            klass.validates(name, length: { minimum: @min_length, maximum: @max_length }.compact)
          end
          if @pattern
            klass.validates(name, format: { with: @pattern })
          end
          if @format
            if JSON_SCHEMA_FORMATS.key?(@format)

              register_format_validation(klass, name)
            else
              raise(ArgumentError, "Invalid format: #{@format}")
            end
          end
        end

        private

        # @param [Class] klass
        # @param [Symbol] name
        def register_format_validation(klass, name)
          if @format.nil?
            return
          end

          format_validator = JSON_SCHEMA_FORMATS[@format]
          if format_validator.nil?
            return
          end

          klass.validate do |record|
            value = record.send(name)

            if !format_validator.call(value)
              record.errors.add(name, :invalid_format, message: "must be a valid #{@format}")
            end
          end
        end
      end
    end
  end
end
