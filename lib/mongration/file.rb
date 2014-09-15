module Mongration

  # @private
  class File
    include Versionable

    def self.all_file_names
      Dir[::File.join(Mongration.dir, '*.rb')].map do |path|
        path.pathmap('%f')
      end
    end

    def self.pending
      wrap(all_file_names - migrated_file_names).sort
    end

    def self.migrated
      wrap(migrated_file_names).sort
    end

    def self.migrated_file_names
      Migration.file_names
    end

    def self.last
      (pending + migrated).max
    end

    def self.wrap(file_names)
      file_names.map { |file_name| new(file_name) }
    end

    attr_reader :file_name

    def initialize(file_name)
      @file_name = file_name
    end

    def up
      load_file
      klass.up
    end

    def down
      load_file
      klass.down
    end

    def name
      underscored_name.gsub('_', ' ')
    end

    def class_name
      underscored_name.camelize
    end

    private

    def load_file
      load(::File.join(Mongration.dir, @file_name))
    end

    def klass
      class_name.constantize
    end

    def underscored_name
      @file_name.chomp('.rb').gsub(/^\d+_/, '')
    end
  end
end
