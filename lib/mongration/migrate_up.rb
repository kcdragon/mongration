module Mongration

  # @private
  class MigrateUp

    def initialize(version)
      @version = version
    end

    def perform
      files_to_migrate.take_while(&:up)
    end

    private

    def files_to_migrate
      File.pending.select { |f| f.version <= @version }
    end
  end
end
