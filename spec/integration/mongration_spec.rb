require 'spec_helper'

describe Mongration do

  class Foo
    class << self
      attr_accessor :instance
    end

    attr_accessor :name
  end

  class Bar
    class << self
      attr_accessor :instance
    end

    attr_accessor :name
  end


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

  def create_first_migration
    create(
      'AddFoo',
      '001_add_foo.rb',
      'Foo.instance = Foo.new',
      'Foo.instance = nil'
    )
  end

  def create_second_migration
    create(
      'AddBar',
      '002_add_bar.rb',
      'Bar.instance = Bar.new',
      'Bar.instance = nil'
    )
  end

  def create_third_migration
    create(
      'AddNameToFoo',
      '0003_add_name_to_foo.rb',
      'foo = Foo.instance; foo.name = "Test"',
      'foo = Foo.instance; foo.name = ""'
    )
  end

  def create_fourth_migration
    create(
      'AddNameToBar',
      '004_add_name_to_bar.rb',
      'bar = Bar.instance; bar.name = "Test"',
      'bar = Bar.instance; bar.name = ""'
    )
  end

  it 'runs a single migration' do
    create_first_migration

    Mongration.migrate

    expect(Foo.instance).to be_present
  end

  it 'skips the first migration and runs a second migration' do
    create_first_migration
    Mongration.migrate

    create_second_migration
    Mongration.migrate

    expect(Foo.instance).to be_present
    expect(Bar.instance).to be_present
  end

  it 'rollsback a migration' do
    create_first_migration
    Mongration.migrate

    Mongration.rollback
    expect(Foo.instance).to be_nil
  end

  it 'can rollback twice' do
    create_first_migration
    Mongration.migrate

    create_second_migration
    Mongration.migrate

    Mongration.rollback
    expect(Foo.instance).to be_present

    Mongration.rollback
    expect(Foo.instance).to be_nil
  end

  it 'does not rollback when there are no migrations' do
    Foo.instance = Foo.new
    Mongration.rollback
    expect(Foo.instance).to be_present
  end

  it 'does not migrate when there are no migrations' do
    create_first_migration
    Mongration.migrate
    Mongration.migrate
    expect(Foo.instance).to be_present
  end

  it 'migrates files in order' do
    create_third_migration
    create_first_migration
    Mongration.migrate

    foo = Foo.instance
    expect(foo.name).to be_present
  end

  it 'rollbacks files in order' do
    create_second_migration
    create_fourth_migration
    Mongration.migrate
    Mongration.rollback

    expect(Bar.instance).to be_nil
  end
end
