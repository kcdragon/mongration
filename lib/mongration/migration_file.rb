module Mongration
  class MigrationFile

    def initialize(path)
      @path = path
    end

    def up
      require_migration(name)
      klass.constantize.up
      Migration.create!(number: number)
    end

    def down
      require_migration(name)
      klass.constantize.down
      Migration.where(number: number).destroy
    end

    def name
      @path.split('/').last
    end

    def number
      name.split('_').first.to_i
    end

    def klass
      name.chomp('.rb').gsub(/^\d+_/, '').camelize
    end

    def require_migration(name)
      require(File.join(Dir.pwd, 'db', 'migrate', name))
    end
  end
end
