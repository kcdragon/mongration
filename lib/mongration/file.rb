module Mongration

  # @private
  class File
    include Comparable

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

    def <=>(other)
      number <=> other.number
    end

    def number
      @file_name.split('_').first.to_i
    end

    def class_name
      @file_name.chomp('.rb').gsub(/^\d+_/, '').camelize
    end

    private

    def load_file
      load(::File.join(Dir.pwd, dir, @file_name))
    end

    def dir
      Mongration.dir
    end

    def klass
      class_name.constantize
    end
  end
end
