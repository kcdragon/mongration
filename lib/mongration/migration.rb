class Mongration::Migration
  include Mongoid::Document

  field :number,  type: Integer
  field :name,    type: String
  field :version, type: Integer
end
