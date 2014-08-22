module Mongration

  # @private
  class File
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
