# JSON Model

[![Gem Version](https://badge.fury.io/rb/json_model_rb.svg)](https://badge.fury.io/rb/json_model_rb)
[![Ruby](https://github.com/gillesbergerp/json_model_rb/actions/workflows/ci.yml/badge.svg)](https://github.com/gillesbergerp/json_model_rb/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Ruby DSL for building JSON Schema definitions with a clean, declarative syntax. Define your
schemas as Ruby classes and generate standards-compliant JSON Schema documents — with attribute
casting and validation provided by ActiveModel.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'json_model_rb'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install json_model_rb
```

## The type DSL: `JsonModel::Types`

Property types are declared with the builders under `JsonModel::Types`
(`Types::String`, `Types::Integer`, `Types::Array`, `Types::OneOf`, …). For brevity, the
examples below assume you have aliased the module locally:

```ruby
require 'json_model'

Types = JsonModel::Types
```

The gem deliberately does **not** define a global alias — in particular it does not define a
top-level `T`, which would collide with [Sorbet](https://sorbet.org)'s `T` namespace.

Parameterizable types are built with `[]` (`Types::String[min_length: 3]`); the two
zero-configuration primitives are used bare (`Types::Boolean`, `Types::Null`). Plain Ruby
classes also work directly as types: `String`, `Integer`, `Float`, `Date`, `DateTime`, `Time`,
`URI`, `Regexp`, and any class that `include`s `JsonModel::Schema`.

## Quick Start

```ruby
class User
  include JsonModel::Schema

  schema_id 'https://example.com/schemas/user.json'
  title 'User'
  description 'A registered user in the system'

  property :name, type: String
  property :email, type: Types::String[format: :email]
  property :age, type: Types::Integer[minimum: 0, maximum: 120], optional: true
end

# `as_schema` returns a Ruby Hash with symbol keys; serialize it with JSON.
puts JSON.pretty_generate(User.as_schema)
```

**Output:**
```json
{
  "$id": "https://example.com/schemas/user.json",
  "title": "User",
  "description": "A registered user in the system",
  "properties": {
    "age": {
      "type": "integer",
      "minimum": 0,
      "maximum": 120
    },
    "email": {
      "type": "string",
      "format": "email"
    },
    "name": {
      "type": "string"
    }
  },
  "required": [
    "email",
    "name"
  ],
  "type": "object"
}
```

> **Note:** `as_schema` returns a symbol-keyed Ruby `Hash` (with `required` as an array of
> symbols). Calling `JSON.generate`/`JSON.pretty_generate` converts symbol keys and values to
> strings, as shown above.

## Schema Metadata

Top-level schema metadata is set directly in the class body:

```ruby
class Product
  include JsonModel::Schema

  schema_id 'https://api.example.com/schemas/product.json'
  schema_version :draft202012
  title 'Product'
  description 'A product available in the catalog'

  property :id, type: String
  property :name, type: String
  property :price, type: Types::Number[minimum: 0]
  property :available, type: Types::Boolean, default: true, optional: true
end
```

### Available metadata keywords

- **`schema_id`** — sets `$id` (the schema's URI identifier).
- **`schema_version`** — sets `$schema`. One of `:draft4`, `:draft6`, `:draft7`, `:draft201909`,
  `:draft202012`.
- **`title`** — a human-readable title.
- **`description`** — a longer explanation of the schema's purpose.
- **`additional_properties`** — whether extra properties are allowed (see below).
- **`unevaluated_properties`** — sets `unevaluatedProperties`.

### A note on `additionalProperties`

By default a schema **rejects unknown attributes at instantiation time** (see
[Validation](#instantiation--validation)). The generated schema only includes an
`additionalProperties` keyword when you set it explicitly:

```ruby
class OpenObject
  include JsonModel::Schema

  additional_properties true
  property :name, type: String
end
```

## Data Types

### Strings

```ruby
class StringExample
  include JsonModel::Schema

  property :simple, type: String
  property :username, type: Types::String[min_length: 3, max_length: 20]
  property :code, type: Types::String[pattern: /\A[A-Z]{3}-\d{4}\z/]
  property :email, type: Types::String[format: :email]
  property :status, type: Types::Enum['draft', 'published', 'archived']
  property :api_version, type: Types::Const['v1']
  property :nickname, type: String, optional: true
end
```

Supported `format:` values include `:date`, `:time`, `:date_time`, `:email`, `:hostname`,
`:ipv4`, `:ipv6`, `:uri`, `:uuid`, `:regex`, `:json_pointer`, and more. Underscored symbols are
emitted with dashes (e.g. `:date_time` → `"date-time"`).

**Output:**
```json
{
  "properties": {
    "api_version": { "const": "v1" },
    "code": { "type": "string", "pattern": "\\A[A-Z]{3}-\\d{4}\\z" },
    "email": { "type": "string", "format": "email" },
    "nickname": { "type": "string" },
    "simple": { "type": "string" },
    "status": { "enum": ["draft", "published", "archived"] },
    "username": { "type": "string", "minLength": 3, "maxLength": 20 }
  },
  "required": ["api_version", "code", "email", "simple", "status", "username"],
  "type": "object"
}
```

### Numbers and integers

```ruby
class NumericExample
  include JsonModel::Schema

  property :count, type: Integer
  property :port, type: Types::Integer[minimum: 1024, maximum: 65535]
  property :positive, type: Types::Integer[exclusive_minimum: 0]
  property :price, type: Types::Number[minimum: 0]
  property :step, type: Types::Integer[multiple_of: 10]
  property :discount, type: Float, optional: true
end
```

**Output:**
```json
{
  "properties": {
    "count": { "type": "integer" },
    "discount": { "type": "number" },
    "port": { "type": "integer", "minimum": 1024, "maximum": 65535 },
    "positive": { "type": "integer", "exclusiveMinimum": 0 },
    "price": { "type": "number", "minimum": 0 },
    "step": { "type": "integer", "multipleOf": 10 }
  },
  "required": ["count", "port", "positive", "price", "step"],
  "type": "object"
}
```

### Booleans

```ruby
class BooleanExample
  include JsonModel::Schema

  property :is_active, type: Types::Boolean
  property :has_agreed, type: Types::Boolean, default: false
  property :enabled, type: Types::Boolean, optional: true
end
```

**Output:**
```json
{
  "properties": {
    "enabled": { "type": "boolean" },
    "has_agreed": { "type": "boolean", "default": false },
    "is_active": { "type": "boolean" }
  },
  "required": ["has_agreed", "is_active"],
  "type": "object"
}
```

### Arrays

```ruby
class ArrayExample
  include JsonModel::Schema

  property :tags, type: Types::Array[String]
  property :numbers, type: Types::Array[Integer, min_items: 1, max_items: 10, unique_items: true]
end
```

**Output:**
```json
{
  "properties": {
    "numbers": {
      "type": "array",
      "items": { "type": "integer" },
      "minItems": 1,
      "maxItems": 10,
      "uniqueItems": true
    },
    "tags": {
      "type": "array",
      "items": { "type": "string" }
    }
  },
  "required": ["numbers", "tags"],
  "type": "object"
}
```

## Schema Composition

Use `Types::AllOf`, `Types::AnyOf`, and `Types::OneOf` to combine schemas. Members may be other
`JsonModel::Schema` classes or any other supported type.

### AllOf — must match all schemas

```ruby
class PersonBase
  include JsonModel::Schema

  property :name, type: String
  property :age, type: Types::Integer[minimum: 0], optional: true
end

class EmployeeDetails
  include JsonModel::Schema

  property :employee_id, type: Types::String[pattern: /\AE-\d{4}\z/]
  property :department, type: String
end

class Employee
  include JsonModel::Schema

  property :record, type: Types::AllOf[PersonBase, EmployeeDetails]
end
```

**Output:**
```json
{
  "properties": {
    "record": {
      "allOf": [
        {
          "properties": {
            "age": { "type": "integer", "minimum": 0 },
            "name": { "type": "string" }
          },
          "required": ["name"],
          "type": "object"
        },
        {
          "properties": {
            "department": { "type": "string" },
            "employee_id": { "type": "string", "pattern": "\\AE-\\d{4}\\z" }
          },
          "required": ["department", "employee_id"],
          "type": "object"
        }
      ]
    }
  },
  "required": ["record"],
  "type": "object"
}
```

`Types::AnyOf` works identically but emits an `anyOf` keyword (the value must validate against at
least one member).

### OneOf — must match exactly one schema

`Types::OneOf` accepts an optional `discriminator:`, the property whose `Const`/`Enum` value
selects the matching member. Combine it with `ref_mode: JsonModel::RefMode::LOCAL` to emit the
members as `$ref`s into `$defs`:

```ruby
class CreditCard
  include JsonModel::Schema

  property :kind, type: Types::Const['credit_card']
  property :number, type: Types::String[pattern: /\A\d{16}\z/]
end

class PayPal
  include JsonModel::Schema

  property :kind, type: Types::Const['paypal']
  property :email, type: Types::String[format: :email]
end

class Payment
  include JsonModel::Schema

  property(
    :payment,
    type: Types::OneOf[CreditCard, PayPal, discriminator: :kind],
    ref_mode: JsonModel::RefMode::LOCAL,
  )
end
```

**Output:**
```json
{
  "properties": {
    "payment": {
      "oneOf": [
        { "$ref": "#/$defs/CreditCard" },
        { "$ref": "#/$defs/PayPal" }
      ]
    }
  },
  "required": ["payment"],
  "$defs": {
    "CreditCard": {
      "properties": {
        "kind": { "const": "credit_card" },
        "number": { "type": "string", "pattern": "\\A\\d{16}\\z" }
      },
      "required": ["kind", "number"],
      "type": "object"
    },
    "PayPal": {
      "properties": {
        "email": { "type": "string", "format": "email" },
        "kind": { "const": "paypal" }
      },
      "required": ["email", "kind"],
      "type": "object"
    }
  },
  "type": "object"
}
```

## Reference modes

A property's `ref_mode:` controls how a referenced schema is rendered:

- `JsonModel::RefMode::INLINE` (default) — the full schema is embedded inline.
- `JsonModel::RefMode::LOCAL` — emit `{ "$ref": "#/$defs/Name" }` and collect the schema under
  the top-level `$defs`.
- `JsonModel::RefMode::EXTERNAL` — emit `{ "$ref": "<schema_id>" }` using the referenced schema's
  `$id`.

## Instantiation & validation

Schema classes are also models. They define typed accessors, cast assigned values, and validate
with ActiveModel:

```ruby
class Account
  include JsonModel::Schema

  property :email, type: Types::String[format: :email]
  property :age, type: Types::Integer[minimum: 0], optional: true
  property :joined_on, type: Date, optional: true
end

account = Account.new(email: 'a@example.com', joined_on: '2020-01-01')
account.email      # => "a@example.com"
account.joined_on  # => #<Date: 2020-01-01> (cast from the ISO 8601 string)
account.valid?     # => true
```

Use `as:` to map a Ruby property name to a different JSON key, and `from_json` to build an
instance from a hash that uses those JSON keys:

```ruby
class Server
  include JsonModel::Schema

  property :remote_path, type: String, as: :remotePath
end

Server.from_json({ remotePath: '/srv' }).remote_path # => "/srv"
```

By default a model validates on instantiation and raises for unknown attributes. Both behaviors
are configurable (see below).

## Configuration

```ruby
JsonModel.configure do |config|
  config.property_naming_strategy = :camel_case          # :identity (default), :camel_case, :pascal_case, or a Proc
  config.schema_id_naming_strategy = :kebab_case_class_name # :none (default), :class_name, :kebab_case_class_name, :snake_case_class_name, or a Proc
  config.schema_id_base_uri = 'https://example.com/schemas/'
  config.schema_version = :draft202012
  config.validate_after_instantiation = true             # raise on invalid input when building a model
end
```

Call `JsonModel.reset_config!` to restore the defaults (useful in test suites).

## Use Cases

- **API documentation** — generate JSON Schemas for request/response validation.
- **Configuration files** — define and validate application configuration.
- **Data validation** — validate incoming data against defined schemas.
- **Code generation** — drive code generation in other languages.
- **OpenAPI/Swagger** — produce schema components for your API specs.

## Resources

- [JSON Schema Specification](https://json-schema.org/)
- [Understanding JSON Schema](https://json-schema.org/understanding-json-schema/)
- [JSON Schema Validator](https://www.jsonschemavalidator.net/)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Credits

Developed and maintained by [gillesbergerp](https://github.com/gillesbergerp).
