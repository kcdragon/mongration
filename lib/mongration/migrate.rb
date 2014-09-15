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
      pending_files = File.pending

      if !pending_files.empty?
        pending_files.sort.each(&:up)

        Mongration.data_store.store_migration(
          @version,
          pending_files.map(&:file_name)
        )
      end
    end
  end
end
