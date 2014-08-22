module Mongration
  module DataStore
    module Mongoid

      # @private
      class Migration
        include ::Mongoid::Document

        field :version, type: Integer
        field :file_names, type: Array
      end
    end
  end
end
