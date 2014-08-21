require 'mongration/migration'
require 'mongration/migration/file'
require 'mongration/migration/null'
require 'mongration/next_migration_query'
require 'mongration/version'

module Mongration
  extend self

  def migrate
    file_names_to_migrate = NextMigrationQuery.file_names_to_migrate

    Migration.
      next_migration_for(file_names_to_migrate).
      up!
  end

  def rollback
    Migration.latest_migration.down!
  end
end
