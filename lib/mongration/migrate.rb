module Mongration

  # @private
  class Migrate

    def self.perform(version)
      new(version).perform
    end

    def initialize(version)
      @version = version
    end

    def perform
      pending_files.sort.each(&:up)
      migration.save
    end

    private

    def pending_files
      File.pending
    end

    def migration
      if pending_files.present?
        Mongration.data_store.build_migration(
          @version,
          pending_files.map(&:file_name)
        )
      else
        NullMigration.new
      end
    end
  end
end
