module Mongration
  class CreateMigration

    def self.perform(name, options = {})
      new(name, options, Mongration.configuration).perform
    end

    def initialize(name, options, configuration)
      @name = name
      @options = options
      @configuration = configuration
    end

    def perform
      MigrationFileWriter.write(
        file_name,
        { dir: @configuration.dir }.merge(@options)
      )
    end

    private

    def file_name
      "#{next_migration_number}_#{snakecase}.rb"
    end

    def next_migration_number
      if @configuration.timestamps?
        Time.now.utc.strftime('%Y%m%d%H%M%S').to_i
      else
        latest_file = Mongration::File.latest

        number = if latest_file
                   latest_file.number + 1
                 else
                   1
                 end
        '%.3d' % number
      end
    end

    def snakecase
      @name.gsub(/([a-z])([A-Z0-9])/, '\1_\2').downcase
    end
  end
end
