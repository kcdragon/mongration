require 'spec_helper'

describe Mongration do

  class GenerativeTest
    class << self; attr_accessor :instance; end
    self.instance = new

    attr_reader :count
    def inc; @count ||= 0; @count += 1; end
  end

  describe 'migrate' do
    it do
      create_migration = ->(class_name, file_name, up, down) {
        migration_contents = "class #{class_name}; def self.up; #{up}; end; end"
        File.open(File.join('spec', 'db', 'migrate', file_name), 'w') do |file|
          file.write(migration_contents)
        end
      }

      number_of_migrations = ->(*) { Rantly { range(1, 10) } }
      created_migrations = ->(*) {
        count = number_of_migrations.call
        count.times do |index|
          create_migration.("Test#{index + 1}", "#{index + 1}_test_#{index + 1}.rb", 'GenerativeTest.instance.inc', '')
        end
        count
      }
      property_of(&created_migrations).check(100) do |n|
        Mongration.migrate
        expect(GenerativeTest.instance.count).to eq(n)

        GenerativeTest.instance = GenerativeTest.new
        Dir.glob(File.join('spec', 'db', 'migrate', '*.rb')).each { |f| File.delete(f) }
        Mongoid.purge!
      end
    end
  end

  after { GenerativeTest.instance = GenerativeTest.new }
end
