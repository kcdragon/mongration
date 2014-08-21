require 'spec_helper'

describe 'application' do

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

    File.open(File.join('db', 'migrate', file_name), 'w') do |file|
      file.write(migration_contents)
    end
  end

  def create_first_migration
    create(
      'AddFoo',
      '001_add_foo.rb',
      'Foo.create!',
      'Foo.destroy_all'
    )
  end

  def create_second_migration
    create(
      'AddBar',
      '002_add_bar.rb',
      'Bar.create!',
      'Bar.destroy_all'
    )
  end

  def create_third_migration
    create(
      'AddNameToFoo',
      '0003_add_name_to_foo.rb',
      'foo = Foo.first; foo.name = "Test"; foo.save!',
      'foo = Foo.first; foo.name = ""; foo.save!'
    )
  end

  def create_fourth_migration
    create(
      'AddNameToBar',
      '004_add_name_to_bar.rb',
      'bar = Bar.first; bar.name = "Test"; bar.save!',
      'bar = Bar.first; bar.name = ""; bar.save!'
    )
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

  it 'does not rollback when there are no migrations' do
    Foo.create!
    Mongration.rollback
    expect(Foo.count).to eq(1)
  end

  it 'does not migrate when there are no migrations' do
    create_first_migration
    Mongration.migrate
    Mongration.migrate
    expect(Foo.count).to eq(1)
  end

  it 'migrates files in order' do
    create_third_migration
    create_first_migration
    Mongration.migrate

    foo = Foo.first
    expect(foo.name).to be_present
  end

  it 'rollbacks files in order' do
    create_second_migration
    create_fourth_migration
    Mongration.migrate
    Mongration.rollback

    expect(Bar.count).to eq(0)
  end
end
