module Mongration
  class Migration
    include Mongoid::Document

    field :number,  type: Integer
    field :version, type: Integer
  end
end
