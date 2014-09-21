namespace :db do

  desc 'Runs #up on any migration files found that have not already been run'
  task migrate: :environment do
    version = ENV['VERSION']
    Mongration.migrate(version)
  end

  desc 'Runs #down on all migration files from the most recent migration'
  task rollback: :environment do
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    Mongration.rollback(step)
  end

  desc 'Returns the version for the most recent migration (i.e. the number of migrations that have been run, not the number of migration files)'
  task version: :environment do
    version = Mongration.version
    Mongration.out.puts "Current version: #{version}"
  end

  namespace :migrate do

    desc 'Creates a new migration file in the migration directory'
    task :create, [:name] => [:environment] do |t, args|
      name = args[:name]
      path = Mongration.create_migration(name)
      Mongration.out.puts "Created #{path}"
    end

    desc 'Outputs a list of files and whether or not they have been migrated'
    task status: :environment do
      migrations = Mongration.status
      Mongration.out.puts ['Status', 'Migration ID' 'Migration Name'].join("\t")
      Mongration.out.puts '-' * 50
      migrations.each do |migration|
        Mongration.out.puts [migration.status, migration.migration_id, migration.migration_name].join("\t")
      end
    end
  end
end
