module Mongration

  # @private
  class MigrateAllUp

    def self.perform
      new.perform
    end

    def perform
      Migrator.new(files_to_migrate).perform
    end

    private

    def files_to_migrate
      File.pending
    end
  end
end
