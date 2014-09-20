module IntegrationFixtures
  def create_migration(file_name, options = {})
    Mongration::CreateMigration::MigrationFileWriter.
      write(file_name + '.rb', options.merge(dir: Mongration.configuration.dir))
  end

  def foo_create_migration
    create_migration(
      '001_add_foo',
      up: 'Foo.instances << Foo.new',
      down: 'Foo.instances.pop'
    )
  end

  def bar_create_migration
    create_migration(
      '002_add_bar',
      up: 'Bar.instances << Bar.new',
      down: 'Bar.instances.pop'
    )
  end

  def foo_update_migration
    create_migration(
      '0003_add_name_to_foo',
      up: 'foo = Foo.instances.first; foo.name = "Test"',
      down: 'foo = Foo.instances.first; foo.name = ""'
    )
  end

  def bar_update_migration
    create_migration(
      '004_add_name_to_bar',
      up: 'bar = Bar.instances.first; bar.name = "Test"',
      down: 'bar = Bar.instances.first; bar.name = ""'
    )
  end
end

class Foo
  class << self
    attr_accessor :instances

    def count
      instances.count
    end
  end

  self.instances = []

  attr_accessor :name
end

class Bar
  class << self
    attr_accessor :instances

    def count
      instances.count
    end
  end

  self.instances = []

  attr_accessor :name
end
