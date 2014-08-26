module IntegrationFixtures
  def create(class_name, file_name, up, down)
    migration_contents =
      <<-EOS
class #{class_name}
  def self.up
    #{up}
  end

  def self.down
    #{down}
  end
end
EOS

    File.open(File.join('spec', 'db', 'migrate', file_name), 'w') do |file|
      file.write(migration_contents)
    end
  end

  def foo_create_migration
    create(
      'AddFoo',
      '001_add_foo.rb',
      'Foo.instances << Foo.new',
      'Foo.instances.pop'
      )
  end

  def bar_create_migration
    create(
      'AddBar',
      '002_add_bar.rb',
      'Bar.instances << Bar.new',
      'Bar.instances.pop'
      )
  end

  def foo_update_migration
    create(
      'AddNameToFoo',
      '0003_add_name_to_foo.rb',
      'foo = Foo.instances.first; foo.name = "Test"',
      'foo = Foo.instances.first; foo.name = ""'
      )
  end

  def bar_update_migration
    create(
      'AddNameToBar',
      '004_add_name_to_bar.rb',
      'bar = Bar.instances.first; bar.name = "Test"',
      'bar = Bar.instances.first; bar.name = ""'
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

RSpec.configure do |config|
  config.include(IntegrationFixtures)
end
