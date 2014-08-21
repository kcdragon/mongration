module Mongration
  module NextMigrationQuery
    extend self

    # Determine the files that need to be migrated.
    #
    # @return [Array]
    #
    def file_names_to_migrate
      all_file_names - Migration.migrated_file_names
    end

    private

    def all_file_names
      Dir[File.join('db', 'migrate', '*.rb')].map do |path|
        path.split('/').last
      end
    end
  end
end
