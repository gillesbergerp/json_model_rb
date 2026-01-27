# JsonModel

[![Gem Version](https://badge.fury.io/rb/json_model_rb.svg)](https://badge.fury.io/rb/json_model_rb)
[![Ruby](https://github.com/gillesbergerp/json_model_rb/actions/workflows/ci.yml/badge.svg)](https://github.com/gillesbergerp/json_model_rb/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

`JsonModel` is a Ruby gem that extends `Dry::Struct` with JSON Schema generation capabilities. It allows you to define robust data models using `dry-types` and `dry-struct` and automatically generate their corresponding JSON Schema (Draft 7).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'json_model_rb'
```

And then execute:

    $ bundle install

## Basic Usage

To use `JsonModel`, include the `JsonModel::Schema` module in your `Dry::Struct` classes.

```ruby
require 'json_model'

class User < Dry::Struct
  include JsonModel::Schema

  attribute :name, JsonModel::Types::String
  attribute :email, JsonModel::Types::Email
  attribute? :age, JsonModel::Types::Integer.optional
end

# Generate JSON Schema
puts User.as_schema
# {
#   :type=>"object",
#   :properties=>{
#     :name=>{:type=>"string"},
#     :email=>{:type=>"string", :format=>"email"},
#     :age=>{:anyOf=>[{:type=>"null"}, {:type=>"integer"}]}
#   },
#   :required=>[:email, :name]
# }
```

## Types and Formats

`JsonModel` provides a set of predefined types in `JsonModel::Types` that map directly to JSON Schema types and formats.

### Primitive Types

Most `Dry::Types` are automatically mapped to their JSON Schema equivalents:

| Dry::Type | JSON Schema Type |
| :--- | :--- |
| `JsonModel::Types::String` | `string` |
| `JsonModel::Types::Integer` | `integer` |
| `JsonModel::Types::Float` | `number` |
| `JsonModel::Types::Bool` | `boolean` |
| `JsonModel::Types::Nil` | `null` |

### Format Types

`JsonModel` includes specialized string types with `format` metadata:

- `JsonModel::Types::Email`: `format: 'email'`
- `JsonModel::Types::UUID`: `format: 'uuid'`
- `JsonModel::Types::URI`: `format: 'uri'`
- `JsonModel::Types::Date`: `format: 'date'`
- `JsonModel::Types::DateTime`: `format: 'date-time'`
- `JsonModel::Types::IPv4`: `format: 'ipv4'`
- `JsonModel::Types::IPv6`: `format: 'ipv6'`
- `JsonModel::Types::Hostname`: `format: 'hostname'`

### Collection Types

- `JsonModel::Types::Array.of(Type)`: Mapped to `type: 'array'` with `items`.
- `JsonModel::Types::UniqueArray`: An array with `uniqueItems: true`.

### Constrained Types

`JsonModel` respects many `dry-types` constraints:

```ruby
attribute :age, JsonModel::Types::Integer.constrained(gteq: 18, lteq: 99)
# JSON Schema: { "type": "integer", "minimum": 18, "maximum": 99 }

attribute :code, JsonModel::Types::String.constrained(format: /\A[A-Z]+\z/)
# JSON Schema: { "type": "string", "pattern": "^[A-Z]+$" }
```

## Advanced Types and Builders

`JsonModel` shines when dealing with complex data structures like references and polymorphic types.

### Local and External References

When a schema refers to another `JsonModel::Schema`, you can use `local` or `external` references to control how the `$ref` is generated.

#### Local References

Use `.local` to generate a relative `$ref` to a definition within the same schema document. This will also add the referenced schema to the `$defs` (or `definitions`) section.

```ruby
class Address < Dry::Struct
  include JsonModel::Schema
  attribute :city, JsonModel::Types::String
end

class User < Dry::Struct
  include JsonModel::Schema
  # Generates "$ref": "#/$defs/Address"
  attribute :address, Address.local
end
```

#### External References

Use `.external` to generate an absolute `$ref` using the schema's `$id`. This is useful when you want to refer to a schema that is defined in another file or hosted at a specific URL.

```ruby
class RemoteUser < Dry::Struct
  include JsonModel::Schema
  
  schema_id "https://example.com/schemas/user.json"
  
  attribute :name, JsonModel::Types::String
end

class Profile < Dry::Struct
  include JsonModel::Schema
  # Generates "$ref": "https://example.com/schemas/user.json"
  attribute :user, RemoteUser.external
end
```

### Composition and Polymorphism

`JsonModel` supports complex type compositions using standard `dry-types` operators and specialized polymorphic builders.

#### Sum Types (`anyOf`)

Simple sum types using the `|` operator are mapped to JSON Schema `anyOf`.

```ruby
attribute :id, JsonModel::Types::Integer | JsonModel::Types::String
# JSON Schema: { "anyOf": [{ "type": "integer" }, { "type": "string" }] }
```

#### Intersection Types (`allOf`)

Intersection types using the `&` operator are mapped to JSON Schema `allOf`. This is useful for combining multiple sets of constraints or schemas.

```ruby
Email = JsonModel::Types::String.constrained(format: /@/)
Unique = JsonModel::Types::String.constrained(min_size: 5)

attribute :contact, Email & Unique
# JSON Schema: { "allOf": [{ "type": "string", "pattern": "@" }, { "type": "string", "minLength": 5 }] }
```

#### Polymorphic Types (`oneOf` / `anyOf`)

For more advanced polymorphic structures, especially tagged unions, `JsonModel` provides `one_of` and `any_of` builders. This is ideal for APIs that return different object types based on a "discriminator" field (e.g., `type` or `kind`).

```ruby
Circle = Class.new(Dry::Struct) do
  include JsonModel::Schema
  attribute :radius, JsonModel::Types::Float
end

Square = Class.new(Dry::Struct) do
  include JsonModel::Schema
  attribute :side, JsonModel::Types::Float
end

Shape = JsonModel::Types.one_of(:type) do
  on :circle, Circle
  on :square, Square
end

class Canvas < Dry::Struct
  include JsonModel::Schema
  attribute :shapes, JsonModel::Types::Array.of(Shape)
end
```

### Builders

Internally, `JsonModel` uses a "Builder" pattern to translate `Dry::Types` into JSON Schema fragments. Every type registered in `JsonModel::Builder` has a corresponding builder class (e.g., `StringBuilder`, `ArrayBuilder`, `RefBuilder`).

You can inspect how a specific type will be rendered:
```ruby
builder = JsonModel::Builder.for(JsonModel::Types::Email)
builder.as_schema # => { type: 'string', format: 'email' }
```

## JSON Schema Features Supported

- `type` (string, number, integer, boolean, object, array, null)
- `properties` and `required`
- `enum` (via `Dry::Types::String.enum(...)`)
- `default` values
- `pattern` (via Regexp constraints)
- `minimum`, `maximum`, `exclusiveMinimum`, `exclusiveMaximum`
- `minLength`, `maxLength`
- `minItems`, `maxItems`, `uniqueItems`
- `anyOf`, `oneOf`, `allOf` (Sum and Intersection types)
- `$ref` and `$defs` for nested schemas

## Configuration

You can configure global options for `JsonModel`, such as naming strategies for properties and schema IDs.

### Attribute Naming and Strategies

By default, JSON property names match the attribute names defined in your `Dry::Struct`. However, you can customize this globally or per attribute.

#### Global Property Naming Strategy

You can set a global strategy to automatically transform attribute names (which are usually snake_case in Ruby) to a different format in the JSON Schema (e.g., camelCase).

```ruby
JsonModel.configure do |config|
  # Available strategies: :identity (default), :camel_case, :pascal_case
  config.property_naming_strategy = :camel_case
end
```

| Strategy | Ruby Attribute | JSON Property |
| :--- | :--- | :--- |
| `:identity` | `user_id` | `user_id` |
| `:camel_case` | `user_id` | `userId` |
| `:pascal_case` | `user_id` | `UserId` |

#### Explicit Aliasing

You can override the global strategy for a specific attribute using the `.as(key)` method on the type.

```ruby
class User < Dry::Struct
  include JsonModel::Schema

  # Forces the JSON property name to be 'ID' regardless of global strategy
  attribute :id, JsonModel::Types::Integer.as(:ID)
  
  # Also works via meta
  attribute :email, JsonModel::Types::String.meta(as: :emailAddress)
end
```

#### Schema ID Naming Strategy

Similarly, you can configure how `$id` is automatically generated for schemas if not explicitly provided.

```ruby
JsonModel.configure do |config|
  # Available strategies: :none (default), :class_name, :kebab_case_class_name, :snake_case_class_name
  config.schema_id_naming_strategy = :kebab_case_class_name
  config.schema_id_base_uri = "https://api.example.com/schemas/"
end

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
