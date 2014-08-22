module Mongration
  module DataStore
    module Mongoid

      # @private
      class Migration
        include ::Mongoid::Document

        field :version, type: Integer
        field :file_names, type: Array

        def self.build(version, file_names)
          new(version: version, file_names: file_names)
        end
      end
    end
  end
end
