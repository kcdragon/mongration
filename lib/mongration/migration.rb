module Mongration

  # @private
  class Migration
    include ::Mongoid::Document

    field :file_name, type: String

    field :created_at, type: Time, default: -> { Time.now }
    field :deleted_at, type: Time

    default_scope -> { where(deleted_at: nil) }

    def self.all_file_names
      Migration.pluck(:file_name)
    end

    def destroy(*)
      self.deleted_at = Time.now
      save!
    end
  end
end
