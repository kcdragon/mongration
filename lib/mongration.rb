require 'mongration/migration'
require 'mongration/migrations'
require 'mongration/version'

module Mongration
  extend self

  def migrate
    all_numbers = migration_files.map do |path|
      name = path.split('/').last
      name.split('_').first.to_i
    end

    migrated_numbers = Migrations.all.pluck(:number)

    numbers_to_migrate = all_numbers - migrated_numbers

    if numbers_to_migrate.present?
      new_version = Migrations.increment
    end

    migration_files.each do |path|
      name = path.split('/').last
      number, *klass = name.split('_')

      number = number.to_i
      klass = klass.join('_').chomp('.rb').camelize

      next unless numbers_to_migrate.include?(number)

      require_migration(name)
      klass.constantize.up
      Migration.create!(name: klass, number: number, version: new_version)
    end
  end

  def rollback
    current_version = Migrations.version
    numbers_to_rollback = Migration.where(version: current_version).pluck(:number)
    migration_files.each do |path|
      name = path.split('/').last
      number, *klass = name.split('_')

      number = number.to_i
      klass = klass.join('_').chomp('.rb').camelize

      next unless numbers_to_rollback.include?(number)

      require_migration(name)
      klass.constantize.down
      Migration.where(number: number).destroy
    end

    Migrations.decrement
  end

  private

  def require_migration(name)
    require(File.join(Dir.pwd, 'db', 'migrate', name))
  end

  def migration_files
    Dir[File.join('db', 'migrate', '*.rb')]
  end
end
