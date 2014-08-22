module Mongration

  # @private
  class Migration

    def self.next_migration_for(file_names)
      if file_names.present?
        migration = Mongration.data_store_class.build(
          latest_migration.version + 1,
          file_names
          )
        new(migration)
      else
        Null.new
      end
    end

    def self.latest_migration
      migrations = Mongration.data_store_class.all.sort_by(&:version).reverse
      if migrations.present?
        new(migrations.first)
      else
        Null.new
      end
    end

    def initialize(migration)
      @migration = migration
    end

    def version
      @migration.version
    end

    def up!
      @migration.file_names.sort_by do |file_name|
        file_name.split('_').first.to_i
      end.each do |file_name|
        dir = Mongration.dir
        require(::File.join(Dir.pwd, dir, file_name))
        klass = file_name.chomp('.rb').gsub(/^\d+_/, '').camelize
        klass.constantize.up
      end

      @migration.save!
    end

    def down!
      @migration.file_names.sort_by do |file_name|
        file_name.split('_').first.to_i
      end.reverse.each do |file_name|
        dir = Mongration.dir
        require(::File.join(Dir.pwd, dir, file_name))
        klass = file_name.chomp('.rb').gsub(/^\d+_/, '').camelize
        klass.constantize.down
      end
      @migration.destroy
    end
  end
end
