require 'spec_helper'

describe 'application' do

  def create_first_migration
    migration_contents =
      <<-EOS
class AddFoo
  def self.up
    Foo.create!
  end

  def self.down
    Foo.destroy_all
  end
end
EOS

    File.open('db/migrate/001_add_foo.rb', 'w') do |file|
      file.write(migration_contents)
    end
  end

  def create_second_migration
    migration_contents =
      <<-EOS
class AddBar
  def self.up
    Bar.create!
  end

  def self.down
    Bar.destroy_all
  end
end
EOS

    File.open('db/migrate/002_add_bar.rb', 'w') do |file|
      file.write(migration_contents)
    end
  end

  it 'runs a single migration' do
    create_first_migration

    Mongration.migrate

    expect(Foo.count).to eq(1)
  end

  it 'skips the first migration and runs a second migration' do
    create_first_migration
    Mongration.migrate

    create_second_migration
    Mongration.migrate

    expect(Foo.count).to eq(1)
    expect(Bar.count).to eq(1)
  end

  it 'rollsback a migration' do
    create_first_migration
    Mongration.migrate

    Mongration.rollback
    expect(Foo.count).to eq(0)
  end

  it 'can rollback twice' do
    create_first_migration
    Mongration.migrate

    create_second_migration
    Mongration.migrate

    Mongration.rollback
    expect(Foo.count).to eq(1)

    Mongration.rollback
    expect(Foo.count).to eq(0)
  end

  after { FileUtils.rm_rf('db/migrate/001_add_foo.rb') }
  after { FileUtils.rm_rf('db/migrate/002_add_bar.rb') }
end
