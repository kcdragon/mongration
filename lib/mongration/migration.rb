module Mongration
  class Migration
    def initialize(migration)
      @migration = migration
    end

    def up
      sorted_file_names.each do |file_name|
        Mongration::File.new(file_name).up
      end
    end

    def down
      sorted_file_names.reverse.each do |file_name|
        Mongration::File.new(file_name).down
      end
    end

    def sorted_file_names
      @migration.file_names.sort_by do |file_name|
        file_name.split('_').first.to_i
      end
    end
  end
end
