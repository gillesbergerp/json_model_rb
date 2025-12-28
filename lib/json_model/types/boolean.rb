# frozen_string_literal: true

module T
  Boolean = Class.new do
    def to_type_spec(**_options) = JsonModel::TypeSpec::Primitive::Boolean.new
  end.new
end
