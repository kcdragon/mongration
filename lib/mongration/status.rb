module Mongration

  # @private
  module Status
    extend self

    FileStatus = Struct.new(:status, :migration_id, :migration_name)

    def migrations
      performed_migrations + pending_migrations
    end

    private

    def performed_migrations
      File.migrated.map do |file|
        FileStatus.new('up', file.id, file.name)
      end
    end

    def pending_migrations
      File.pending.map do |file|
        FileStatus.new('down', file.id, file.name)
      end
    end
  end
end
