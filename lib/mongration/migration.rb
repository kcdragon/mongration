module Mongration

  # @private
  class Migration
    def initialize(migration)
      @migration = migration
    end

    def up
      files.sort.each(&:up)
    end

    def down
      files.sort.reverse.each(&:down)
    end

    private

    def files
      @migration.file_names.map do |file_name|
        Mongration::File.new(file_name)
      end
    end
  end
end
