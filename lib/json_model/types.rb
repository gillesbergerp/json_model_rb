# frozen_string_literal: true

module JsonModel
  # Friendly, namespaced aliases for the {TypeSpec} hierarchy. This is the DSL
  # used when declaring property types, e.g.
  # +property(:name, type: JsonModel::Types::String[min_length: 3])+.
  #
  # Parameterizable types are referenced as classes and built with +[]+
  # (+Types::String[...]+, +Types::Array[...]+, +Types::OneOf[...]+). The two
  # zero-configuration primitives are exposed as ready-to-use instances so they
  # can be used bare (+Types::Boolean+, +Types::Null+).
  #
  # Consumers may locally alias this module for brevity (e.g. +Types = JsonModel::Types+);
  # the gem deliberately does not define a top-level alias (notably not +T+, which
  # collides with Sorbet).
  module Types
    String = TypeSpec::Primitive::String
    Integer = TypeSpec::Primitive::Integer
    Number = TypeSpec::Primitive::Number
    Array = TypeSpec::Array
    Const = TypeSpec::Const
    Enum = TypeSpec::Enum
    AllOf = TypeSpec::Composition::AllOf
    AnyOf = TypeSpec::Composition::AnyOf
    OneOf = TypeSpec::Composition::OneOf

    Boolean = TypeSpec::Primitive::Boolean.new
    Null = TypeSpec::Primitive::Null.new
  end
end
