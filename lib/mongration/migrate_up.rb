module Mongration

  # @private
  class MigrateUp

    def initialize(version)
      @version = version
    end

    def perform
      files_to_migrate.each(&:up)
      true
    end

    private

    def files_to_migrate
      if @version
        File.pending.select { |f| f.version <= @version }
      else
        File.pending
      end
    end
  end
end
