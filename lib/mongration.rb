require "mongration/version"

module Mongration
  extend self

  def perform
    migration_files = Dir[File.join('db', 'migrate', '*.rb')]
    all_numbers = migration_files.map do |path|
      name = path.split('/').last
      name.split('_').first.to_i
    end

    migrated_numbers = Migrations.all.pluck(:number)

    numbers_to_migrate = all_numbers - migrated_numbers

    if numbers_to_migrate.present?
      new_version = Migrations.current.increment
    end

    migration_files.each do |path|
      name = path.split('/').last
      number, *klass = name.split('_')

      number = number.to_i
      klass = klass.join('_').chomp('.rb').camelize

      next unless numbers_to_migrate.include?(number)

      require File.join(Dir.pwd, 'db', 'migrate', name)
      klass.constantize.up
      Migration.create!(name: klass, number: number, version: new_version)
    end
  end

  class Migration
    include Mongoid::Document

    field :number,  type: Integer
    field :name,    type: String
    field :version, type: Integer
  end

  class Migrations
    include Mongoid::Document

    field :version, type: Integer, default: 0

    def self.current
      first || create!
    end

    def increment
      inc(:version, 1)
    end

    def decrement
      if version <= 0
        update_attribute(:version, 0)
        0
      else
        inc(:version, -1)
      end
    end
  end
end
