module Mongration

  # @private
  class File
    include Comparable

    def initialize(file_name)
      @file_name = file_name

      require_file
    end

    def up
      klass.up
    end

    def down
      klass.down
    end

    def <=>(other)
      number <=> other.number
    end

    protected

    def number
      @file_name.split('_').first.to_i
    end

    private

    def require_file
      require(::File.join(Dir.pwd, dir, @file_name))
    end

    def dir
      Mongration.dir
    end

    def klass
      @file_name.chomp('.rb').gsub(/^\d+_/, '').camelize.constantize
    end
  end
end
