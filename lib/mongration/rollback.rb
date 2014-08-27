module Mongration

  # @private
  class Rollback

    def self.perform(migration)
      new(migration).perform
    end

    def initialize(migration)
      @migration = migration
    end

    def perform
      files_to_rollback.sort.reverse.each(&:down)
      @migration.destroy
    end

    private

    def files_to_rollback
      @migration.file_names.map do |file_name|
        Mongration::File.new(file_name)
      end
    end
  end
end
