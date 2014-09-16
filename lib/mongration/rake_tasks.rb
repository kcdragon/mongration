namespace :db do

  desc 'Runs #up on any migration files found that have not already been run'
  task migrate: :environment do
    version = ENV['VERSION']
    success = Mongration.migrate(version)

    if version && !success
      $stdout.puts "Invalid Version: #{version} does not exist."
    end
  end

  desc 'Runs #down on all migration files from the most recent migration'
  task rollback: :environment do
    Mongration.rollback
  end

  desc 'Returns the version for the most recent migration (i.e. the number of migrations that have been run, not the number of migration files)'
  task version: :environment do
    version = Mongration.version
    $stdout.puts "Current version: #{version}"
  end

  namespace :migrate do

    desc 'Creates a new migration file in the migration directory'
    task :create, [:name] => [:environment] do |t, args|
      name = args[:name]
      file_name = Mongration.create_migration(name)
      $stdout.puts "Created #{File.join(Mongration.dir, file_name)}"
    end

    desc 'Outputs a list of files and whether or not they have been migrated'
    task status: :environment do
      migrations = Mongration.status
      $stdout.puts ['Status', 'Migration ID' 'Migration Name'].join("\t")
      $stdout.puts '-' * 50
      migrations.each do |migration|
        $stdout.puts [migration.status, migration.migration_id, migration.migration_name].join("\t")
      end
    end
  end
end
