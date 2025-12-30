# frozen_string_literal: true

module T
  Null = Class.new do
    def to_type_spec = JsonModel::TypeSpec::Primitive::Null.new
  end.new
end
