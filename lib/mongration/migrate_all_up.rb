module Mongration

  # @private
  class MigrateAllUp

    def self.perform
      new.perform
    end

    def perform
      files_to_migrate.take_while(&:up)
    end

    private

    def files_to_migrate
      File.pending
    end
  end
end
