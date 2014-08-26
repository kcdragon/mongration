require 'spec_helper'

describe Mongration do

  it 'creates number-based template with CamelCase file name' do
    Mongration.create_migration('AddFoo')

    migration_file_name = File.join('spec', 'db', 'migrate', '001_add_foo.rb')
    expect(File.exists?(migration_file_name)).to eq(true)
  end

  it 'creates number-based template with snake_case file name' do
    Mongration.create_migration('add_foo')

    migration_file_name = File.join('spec', 'db', 'migrate', '001_add_foo.rb')
    expect(File.exists?(migration_file_name)).to eq(true)
  end

  it 'creates time-based template' do
    Mongration.configure do |config|
      config.timestamps = true
    end

    Timecop.freeze(Time.utc(2014, 1, 1, 1, 1, 1)) do
      Mongration.create_migration('add_foo')
    end

    migration_file_name = File.join('spec', 'db', 'migrate', '20140101010101_add_foo.rb')
    expect(File.exists?(migration_file_name)).to eq(true)
  end

  it 'increments migration number' do
    Mongration.create_migration('add_foo')
    Mongration.migrate
    Mongration.create_migration('add_bar')

    migration_file_name = File.join('spec', 'db', 'migrate', '002_add_bar.rb')
    expect(File.exists?(migration_file_name)).to eq(true)
  end

  it 'includes non-migrated files when determining migration number' do
    Mongration.create_migration('add_foo')
    Mongration.create_migration('add_bar')

    migration_file_name = File.join('spec', 'db', 'migrate', '002_add_bar.rb')
    expect(File.exists?(migration_file_name)).to eq(true)
  end

  it 'creates file with migration class' do
    Mongration.create_migration('add_foo', up: 'puts "up"', down: 'puts "down"')

    migration_file_name = File.join('spec', 'db', 'migrate', '001_add_foo.rb')
    contents = File.open(migration_file_name) do |file|
      file.read
    end

    expect(contents).to eq(<<EOS
class AddFoo
  def self.up
    puts "up"
  end

  def self.down
    puts "down"
  end
end
EOS
    )
  end
end
