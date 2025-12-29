# JSON Model

[![Gem Version](https://badge.fury.io/rb/json_model_rb.svg)](https://badge.fury.io/rb/json_model_rb)
[![Ruby](https://github.com/gillesbergerp/json_model_rb/actions/workflows/ci.yml/badge.svg)](https://github.com/gillesbergerp/json_model_rb/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Ruby DSL for building JSON Schema definitions with a clean, declarative syntax. Define your schemas in Ruby and generate complete, standards-compliant JSON Schema documents.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'json_model'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install json_model
```

## Quick Start

```ruby
require 'json_model'

class User
  include JsonModel::Schema

  schema_id "https://example.com/schemas/user.json"
  title "User"
  description "A registered user in the system"

  property :name, type: String
  property :email, type: String, format: :email
  property :age, type: Integer, minimum: 0, maximum: 120, optional: true
end

# Generate the JSON Schema
puts JSON.pretty_generate(User.as_schema)
```

**Output:**
```json
{
  "$id": "https://example.com/schemas/user.json",
  "additionalProperties": false,
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
    {
      "json_class": "Symbol",
      "s": "email"
    },
    {
      "json_class": "Symbol",
      "s": "name"
    }
  ],
  "type": "object"
}
```

## Schema Metadata

You can set top-level schema metadata properties directly in your schema class:

```ruby
class Product
  include JsonModel::Schema

  # Schema metadata
  schema_id "https://api.example.com/schemas/product.json"
  schema_version :draft_2020_12
  title "Product"
  description "A product available in the catalog"
  
  # Properties
  property :id, type: String
  property :name, type: String
  property :price, type: Float, minimum: 0
  property :available, type: T::Boolean, default: true, optional: true
end
```

### Available Metadata Keywords

- **`schema_id`** - Sets the `$id` (unique URI identifier for the schema)
- **`schema_version`** - Sets the `$schema` (JSON Schema version)
- **`title`** - Human-readable title for the schema
- **`description`** - Detailed explanation of the schema's purpose
- **`additional_properties`** - Whether additional properties are allowed (default: `false`)

## Data Types

### String Type

```ruby
class StringExample
  include JsonModel::Schema

  # Basic string
  property :simple_string, type: String

  # String with length constraints
  property :username, type: String, 
    min_length: 3,
    max_length: 20

  # String with pattern (regex)
  property :product_code, type: String, pattern: /\A[A-Z]{3}-\d{4}\z/

  # String with format
  property :email, type: String, format: :email
  property :uri, type: String, format: :uri
  property :hostname, type: String, format: :hostname
  property :ipv4, type: String, format: :ipv4
  property :ipv6, type: String, format: :ipv6
  property :uuid, type: String, format: :uuid
  property :date, type: String, format: :date
  property :time, type: String, format: :time
  property :datetime, type: String, format: :date_time
  property :duration, type: String, format: :duration
  
  # String with enum
  property :status, type: String, enum: ["draft", "published", "archived"]
  
  # String with const
  property :api_version, type: String, const: "v1"
  
  # Optional string
  property :nickname, type: String, optional: true
end

# Generate the JSON Schema
puts JSON.pretty_generate(StringExample.as_schema)
```

**Output:**
```json
{
  "additionalProperties": false,
  "properties": {
    "date": {
      "type": "string",
      "format": "date"
    },
    "datetime": {
      "type": "string",
      "format": "date-time"
    },
    "duration": {
      "type": "string",
      "format": "duration"
    },
    "email": {
      "type": "string",
      "format": "email"
    },
    "hostname": {
      "type": "string",
      "format": "hostname"
    },
    "ipv4": {
      "type": "string",
      "format": "ipv4"
    },
    "ipv6": {
      "type": "string",
      "format": "ipv6"
    },
    "product_code": {
      "type": "string",
      "pattern": "\\A[A-Z]{3}-\\d{4}\\z"
    },
    "simple_string": {
      "type": "string"
    },
    "time": {
      "type": "string",
      "format": "time"
    },
    "uri": {
      "type": "string",
      "format": "uri"
    },
    "username": {
      "type": "string",
      "minLength": 3,
      "maxLength": 20
    },
    "uuid": {
      "type": "string",
      "format": "uuid"
    }
  },
  "required": [
    "date",
    "datetime",
    "duration",
    "email",
    "hostname",
    "ipv4",
    "ipv6",
    "product_code",
    "simple_string",
    "time",
    "uri",
    "username",
    "uuid"
  ],
  "type": "object"
}
```

### Number and Integer Types

```ruby
class NumericExample
  include JsonModel::Schema

  # Integer
  property :count, type: Integer

  # Integer with range
  property :port, type: Integer, minimum: 1024, maximum: 65535

  # Integer with exclusive bounds
  property :positive_int, type: Integer, exclusive_minimum: 0

  # Number (float/double)
  property :price, type: Float, minimum: 0

  # Number with multiple_of
  property :quantity, type: Integer, multiple_of: 10

  # Number with precision
  property :temperature, type: Float, minimum: -273.15, maximum: 1000.0
  
  # Optional number
  property :discount, type: Float, optional: true
end

# Generate the JSON Schema
puts JSON.pretty_generate(NumericExample.as_schema)
```

**Output:**
```json
{
  "additionalProperties": false,
  "properties": {
    "count": {
      "type": "integer"
    },
    "discount": {
      "type": "number"
    },
    "port": {
      "type": "integer",
      "minimum": 1024,
      "maximum": 65535
    },
    "positive_int": {
      "type": "integer",
      "exclusiveMinimum": 0
    },
    "price": {
      "type": "number",
      "minimum": 0
    },
    "quantity": {
      "type": "integer",
      "multipleOf": 10
    },
    "temperature": {
      "type": "number",
      "minimum": -273.15,
      "maximum": 1000.0
    }
  },
  "required": [
    "count",
    "port",
    "positive_int",
    "price",
    "quantity",
    "temperature"
  ],
  "type": "object"
}
```

### Boolean Type

```ruby
class BooleanExample
  include JsonModel::Schema

  property :is_active, type: T::Boolean
  property :has_agreed, type: T::Boolean, default: false
  property :enabled, type: T::Boolean, optional: true
end

# Generate the JSON Schema
puts JSON.pretty_generate(BooleanExample.as_schema)
```

**Output:**
```json
{
  "additionalProperties": false,
  "properties": {
    "enabled": {
      "type": "boolean"
    },
    "has_agreed": {
      "type": "boolean",
      "default": false
    },
    "is_active": {
      "type": "boolean"
    }
  },
  "required": [
    "has_agreed",
    "is_active"
  ],
  "type": "object"
}
```

### Array Type

```ruby
class ArrayExample
  include JsonModel::Schema

  # Simple array
  property :tags, type: T::Array[String]

  # Array with constraints
  property :numbers, type: T::Array[Integer], min_items: 1, max_items: 10, unique_items: true
end

# Generate the JSON Schema
puts JSON.pretty_generate(ArrayExample.as_schema)
```

**Output:**
```json
{
  "additionalProperties": false,
  "properties": {
    "numbers": {
      "type": "array",
      "items": {
        "type": "integer"
      },
      "minItems": 1,
      "maxItems": 10,
      "uniqueItems": true
    },
    "tags": {
      "type": "array",
      "items": {
        "type": "string"
      }
    }
  },
  "required": [
    "numbers",
    "tags"
  ],
  "type": "object"
}
```

## Schema Composition

JSON Model supports powerful schema composition using `T::AllOf`, `T::AnyOf`, and `T::OneOf`:

### AllOf - Must Match All Schemas

Use `T::AllOf` when a value must validate against all provided schemas (intersection/combining schemas):

```ruby
class PersonBase
  include JsonModel::Schema

  property :name, type: String
  property :age, type: Integer, minimum: 0, optional: true
end

class EmployeeDetails
  include JsonModel::Schema

  property :employee_id, type: String, pattern: /\AE-\d{4}\z/
  property :department, type: String
  property :salary, type: Float, minimum: 0, optional: true
end

class Employee
  include JsonModel::Schema

  title "Employee"
  description "Combines person and employee-specific properties"

  property :employee, type: T::AllOf[PersonBase, EmployeeDetails]
end

# Generate the JSON Schema
puts JSON.pretty_generate(Employee.as_schema)
```

**Output:**
```json
{
  "additionalProperties": false,
  "title": "Employee",
  "description": "Combines person and employee-specific properties",
  "properties": {
    "employee": {
      "allOf": [
        {
          "additionalProperties": false,
          "properties": {
            "age": {
              "type": "integer",
              "minimum": 0
            },
            "name": {
              "type": "string"
            }
          },
          "required": [
            "name"
          ],
          "type": "object"
        },
        {
          "additionalProperties": false,
          "properties": {
            "department": {
              "type": "string"
            },
            "employee_id": {
              "type": "string",
              "pattern": "\\AE-\\d{4}\\z"
            },
            "salary": {
              "type": "number",
              "minimum": 0
            }
          },
          "required": [
            "department",
            "employee_id"
          ],
          "type": "object"
        }
      ]
    }
  },
  "required": [
    "employee"
  ],
  "type": "object"
}
```

### AnyOf - Must Match At Least One Schema

Use `T::AnyOf` when a value must validate against one or more schemas (union/alternatives):

```ruby
class EmailContact
  include JsonModel::Schema

  property :email, type: String, format: :email
end

class PhoneContact
  include JsonModel::Schema

  property :phone, type: String, pattern: /\A\+?[1-9]\\d{1,14}\z/
end

class AddressContact
  include JsonModel::Schema

  property :street, type: String
  property :city, type: String
end

class Contact
  include JsonModel::Schema

  title "Contact Method"
  description "Must provide at least one contact method"

  property :contact, type: T::AnyOf[EmailContact, PhoneContact, AddressContact]
end

# Generate the JSON Schema
puts JSON.pretty_generate(Contact.as_schema)
```

**Output:**
```json
{
  "additionalProperties": false,
  "title": "Contact Method",
  "description": "Must provide at least one contact method",
  "properties": {
    "contact": {
      "anyOf": [
        {
          "additionalProperties": false,
          "properties": {
            "email": {
              "type": "string",
              "format": "email"
            }
          },
          "required": [
            "email"
          ],
          "type": "object"
        },
        {
          "additionalProperties": false,
          "properties": {
            "phone": {
              "type": "string",
              "pattern": "\\A\\+?[1-9]\\\\d{1,14}\\z"
            }
          },
          "required": [
            "phone"
          ],
          "type": "object"
        },
        {
          "additionalProperties": false,
          "properties": {
            "city": {
              "type": "string"
            },
            "street": {
              "type": "string"
            }
          },
          "required": [
            "city",
            "street"
          ],
          "type": "object"
        }
      ]
    }
  },
  "required": [
    "contact"
  ],
  "type": "object"
}
```

### OneOf - Must Match Exactly One Schema

Use `T::OneOf` when a value must validate against exactly one schema (exclusive alternatives):

```ruby
class CreditCardPayment
  include JsonModel::Schema

  property :payment_type, type: String, const: "credit_card"
  property :card_number, type: String, pattern: /\A\d{16}\z/
  property :cvv, type: String, pattern: /\A\d{3,4}\z/
  property :expiry, type: String, pattern: /\A\d{2}\/\d{2}\z/
end

class PayPalPayment
  include JsonModel::Schema

  property :payment_type, type: String, const: "paypal"
  property :paypal_email, type: String, format: :email
end

class BankTransferPayment
  include JsonModel::Schema

  property :payment_type, type: String, const: "bank_transfer"
  property :iban, type: String, pattern: "^[A-Z]{2}\\d{2}[A-Z0-9]+$"
  property :swift, type: String, optional: true
end

class PaymentMethod
  include JsonModel::Schema

  title "Payment Method"
  description "Must specify exactly one payment method"

  property :payment, type: T::OneOf[CreditCardPayment, PayPalPayment, BankTransferPayment]
end

# Generate the JSON Schema
puts JSON.pretty_generate(PaymentMethod.as_schema)
```

**Output:**
```json
{
  "additionalProperties": false,
  "title": "Payment Method",
  "description": "Must specify exactly one payment method",
  "properties": {
    "payment": {
      "oneOf": [
        {
          "additionalProperties": false,
          "type": "object"
        },
        {
          "additionalProperties": false,
          "type": "object"
        },
        {
          "additionalProperties": false,
          "type": "object"
        }
      ]
    }
  },
  "required": [
    "payment"
  ],
  "type": "object"
}
```

## Use Cases

- **API Documentation**: Generate JSON schemas for API request/response validation
- **Configuration Files**: Define and validate application configuration schemas
- **Data Validation**: Validate incoming data against defined schemas
- **Code Generation**: Use schemas to generate code in other languages
- **OpenAPI/Swagger**: Generate OpenAPI schema definitions for your APIs
- **Form Generation**: Generate forms from schema definitions

## Resources

- [JSON Schema Specification](https://json-schema.org/)
- [Understanding JSON Schema](https://json-schema.org/understanding-json-schema/)
- [JSON Schema Validator](https://www.jsonschemavalidator.net/)
- [Draft 7 Reference](https://json-schema.org/draft-07/json-schema-release-notes.html)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Credits

Developed and maintained by [gillesbergerp](https://github.com/gillesbergerp).