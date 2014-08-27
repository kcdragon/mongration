module Mongration
  module DataStore
    module Mongoid

      # @private
      class Migration
        include ::Mongoid::Document

        field :version,    type: Integer
        field :file_names, type: Array

        field :created_at, type: Time, default: -> { Time.now }
        field :deleted_at, type: Time

        default_scope where(deleted_at: nil)

        def destroy(*)
          self.deleted_at = Time.now
          save!
        end
      end
    end
  end
end
