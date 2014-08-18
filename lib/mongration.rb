require 'mongration/migration'
require 'mongration/migration_file'
require 'mongration/migrations'
require 'mongration/version'

module Mongration
  extend self

  def migrate
    all_numbers = migration_files.map(&:number)
    migrated_numbers = Migrations.all.pluck(:number)
    numbers_to_migrate = all_numbers - migrated_numbers

    if numbers_to_migrate.present?
      new_version = Migrations.increment
    end

    migration_files.select do |migration_file|
      numbers_to_migrate.include?(migration_file.number)
    end.each(&:up)

    if numbers_to_migrate.present?
      Migration.in(number: numbers_to_migrate).
        update_all(version: new_version)
    end
  end

  def rollback
    current_version = Migrations.version
    numbers_to_rollback = Migration.where(version: current_version).pluck(:number)
    migration_files.select do |migration_file|
      numbers_to_rollback.include?(migration_file.number)
    end.each(&:down)

    Migrations.decrement
  end

  private

  def migration_files
    Dir[File.join('db', 'migrate', '*.rb')].map do |path|
      MigrationFile.new(path)
    end
  end
end
