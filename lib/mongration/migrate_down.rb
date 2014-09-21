module Mongration

  # @private
  class MigrateDown

    def initialize(version)
      @version = version
    end

    def perform
      files_to_rollback.each(&:down)
    end

    private

    def files_to_rollback
      File.migrated.select { |f| f.version > @version }.reverse
    end
  end
end
