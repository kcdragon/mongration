module Mongration

  # @private
  class File
    include Comparable

    def self.all_file_names
      Dir[::File.join(Mongration.configuration.dir, '*.rb')].map do |path|
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

    def self.all
      pending + migrated
    end

    def self.last
      all.max
    end

    def self.wrap(file_names)
      file_names.map { |file_name| new(file_name) }
    end

    attr_reader :file_name

    def initialize(file_name)
      @file_name = file_name
    end

    def up
      with_summary(:up) do
        load_file
        klass.up
        Migration.create_by_file_name(file_name)
      end
    end

    def down
      with_summary(:down) do
        load_file
        klass.down
        Migration.destroy_by_file_name(file_name)
      end
    end

    def name
      underscored_name.gsub('_', ' ')
    end

    def class_name
      underscored_name.camelize
    end

    def version
      file_name.split('_').first
    end

    def number
      version.to_i
    end

    def <=>(other)
      number <=> other.number
    end

    def load_file
      load(::File.join(Mongration.configuration.dir, @file_name))
    end

    def klass
      class_name.constantize
    end

    private

    def underscored_name
      @file_name.chomp('.rb').gsub(/^\d+_/, '')
    end

    def with_summary(direction)
      description = "#{version} #{class_name}"

      before, after = nil, nil
      case direction
      when :up
        before, after = 'migrating', 'migrated'
      when :down
        before, after = 'reverting', 'reverted'
      end

      Mongration.out.puts("#{description}: #{before}")
      yield
      Mongration.out.puts("#{description}: #{after}")
      Mongration.out.puts
      true
    rescue => e
      Mongration.out.puts("#{e.inspect}: An error has occured, this and all later migrations cancelled")
      e.backtrace.each do |line|
        Mongration.out.puts(line)
      end
      false
    end
  end
end
