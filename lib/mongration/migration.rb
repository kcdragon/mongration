module Mongration

  # @private
  class Migration
    def initialize(migration)
      @migration = migration
    end

    def up
      sorted_files.each(&:up)
    end

    def down
      sorted_files.reverse.each(&:down)
    end

    private

    def sorted_files
      files.sort
    end

    def files
      @migration.file_names.map do |file_name|
        Mongration::File.new(file_name)
      end
    end
  end
end
