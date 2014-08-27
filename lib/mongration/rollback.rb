module Mongration
  class Rollback

    def self.perform(migration)
      new(migration).perform
    end

    def initialize(migration)
      @migration = migration
    end

    def perform
      files.sort.reverse.each(&:down)
      @migration.destroy
    end

    private

    def files
      @migration.file_names.map do |file_name|
        Mongration::File.new(file_name)
      end
    end
  end
end
