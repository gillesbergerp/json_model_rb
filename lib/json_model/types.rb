# frozen_string_literal: true

require('resolv')
require_relative('types/alias')
require_relative('types/any_of')
require_relative('types/one_of')
require_relative('types/ref')

module JsonModel
  module Types
    include(Dry.Types())

    Date = Dry::Types['date'].meta(format: 'date')

    DateTime = Dry::Types['date_time'].meta(format: 'date-time')

    Email = String.constrained(format: URI::MailTo::EMAIL_REGEXP).meta(format: 'email')

    Hostname = String.constrained(
      format: /(?i)^(?:([a-z0-9-]+|\*)\.)?([a-z0-9-]{1,61})\.([a-z0-9]{2,7})$/,
    ).meta(format: 'hostname')

    IPv4 = String.constrained(
      format: ::Resolv::IPv4::Regex,
    ).meta(format: 'ipv4')

    IPv6 = String.constrained(
      format: ::Resolv::IPv6::Regex,
    ).meta(format: 'ipv6')

    Time = Dry::Types['time'].meta(format: 'time')

    UUID = String.constrained(
      format: /^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/,
    ).meta(format: 'uuid')

    URI = String.constrained(
      format: ::URI::DEFAULT_PARSER.make_regexp,
    ).meta(format: 'uri')

    UriReference = String.constrained(
      format: %r{^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?},
    ).meta(format: 'uri-reference')

    Regex = String.constrained(
      format: %r{\A(/?)(.+)\1([a-z]*)\z}i,
    ).meta(format: 'regex')

    UniqueArray = Array.constrained(unique: true)
  end
end
