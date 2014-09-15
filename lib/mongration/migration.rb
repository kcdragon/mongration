module Mongration

  # @private
  class Migration
    include Mongoid::Document
    include Versionable

    field :file_name, type: String

    field :created_at, type: Time, default: -> { Time.now }
    field :deleted_at, type: Time

    default_scope -> { where(deleted_at: nil) }

    def self.create_by_file_name(file_name)
      create(file_name: file_name)
    end

    def self.file_names
      Migration.pluck(:file_name)
    end

    def self.last
      all.to_a.max
    end

    def destroy(*)
      self.deleted_at = Time.now
      save!
    end
  end
end
