module Mongration

  # @private
  module NextMigrationQuery
    extend self

    # Determine the files that need to be migrated.
    #
    # @return [Array]
    #
    def file_names_to_migrate
      all_file_names - migrated_file_names
    end

    private

    def all_file_names
      dir = Mongration.dir
      Dir[File.join(dir, '*.rb')].map do |path|
        path.split('/').last
      end
    end

    def migrated_file_names
      Mongration.data_store_class.all.flat_map do |migration|
        migration.file_names
      end
    end
  end
end
