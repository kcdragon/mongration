module Mongration

  # @private
  class MigrateUp

    def initialize(version)
      @version = version
    end

    def perform
      Migrator.new(files_to_migrate).perform
    end

    private

    def files_to_migrate
      File.pending.select { |f| f.version <= @version }
    end
  end
end
