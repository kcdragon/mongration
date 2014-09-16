module Mongration

  # @private
  class Rollback

    def self.perform
      new.perform
    end

    def perform
      return unless Migration.exists?
      file = File.migrated.last
      file.down
    end
  end
end
