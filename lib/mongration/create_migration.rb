require 'mongration/create_migration/migration_file_writer'

module Mongration

  # @private
  class CreateMigration

    def self.perform(name, options = {})
      new(name, options).perform
    end

    def initialize(name, options)
      @options = options

      snakecase = name.gsub(/([a-z])([A-Z0-9])/, '\1_\2').downcase
      @file_name = "#{next_migration_number}_#{snakecase}.rb"
    end

    def perform
      MigrationFileWriter.write(
        @file_name,
        @options
      )
    end

    private

    def next_migration_number
      if Mongration.configuration.timestamps?
        Time.now.utc.strftime('%Y%m%d%H%M%S').to_i
      else
        latest_file = File.last

        number = if latest_file
                   latest_file.number + 1
                 else
                   1
                 end
        '%.3d' % number
      end
    end
  end
end
