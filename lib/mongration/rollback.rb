module Mongration

  # @private
  class Rollback

    def initialize(file_names)
      @file_names = file_names
    end

    def perform
      files_to_rollback.sort.reverse.each(&:down)
      Mongration.data_store.remove_migration(Mongration.data_store.latest_migration_version)
    end

    private

    def files_to_rollback
      Mongration::File.wrap(@file_names)
    end
  end
end
