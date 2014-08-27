module Mongration

  # @private
  class Migrate

    def self.perform(version)
      new(version, Mongration.configuration.data_store).perform
    end

    def initialize(version, data_store)
      @version = version
      @data_store = data_store
    end

    def perform
      files_to_migrate.sort.each(&:up)
      migration.save
    end

    private

    def files_to_migrate
      migration.file_names.map do |file_name|
        Mongration::File.new(file_name)
      end
    end

    def migration
      @migration ||=
        if file_names.present?
          @data_store.build_migration(
            @version,
            file_names
          )
        else
          NullMigration.new
        end
    end

    def file_names
      all_file_names - migrated_file_names
    end

    def all_file_names
      Mongration::File.all.map(&:file_name)
    end

    def migrated_file_names
      @data_store.migrations.flat_map(&:file_names)
    end
  end
end
