require 'spec_helper'

describe 'application' do

  it 'runs a single migration' do
    class Foo; include Mongoid::Document; end

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

    Mongration.perform

    expect(Foo.count).to eq(1)
  end

  after { FileUtils.rm_rf('db/migrate/001_add_foo.rb') }
  after { Object.send(:remove_const, :Foo) }
end
