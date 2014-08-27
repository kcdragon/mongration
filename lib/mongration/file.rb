module Mongration

  # @private
  class File
    include Comparable

    def self.all
      Dir[::File.join(Mongration.configuration.dir, '*.rb')].map do |path|
        path.pathmap('%f')
      end.map { |file_name| new(file_name) }
    end

    def self.latest
      all.max
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

    def number
      @file_name.split('_').first.to_i
    end

    def <=>(other)
      number <=> other.number
    end

    def class_name
      @file_name.chomp('.rb').gsub(/^\d+_/, '').camelize
    end

    private

    def load_file
      load(::File.join(Dir.pwd, Mongration.configuration.dir, @file_name))
    end

    def klass
      class_name.constantize
    end
  end
end
