module Mongration

  # @private
  class Rollback

    def perform
      return unless Migration.exists?
      migration = Migration.last
      file = File.new(migration.file_name)
      file.down
      migration.destroy
    end
  end
end
