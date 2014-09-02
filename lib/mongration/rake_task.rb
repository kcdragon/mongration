namespace :db do

  desc 'Runs #up on any migration files found that have not already been run'
  task migrate: :environment do
    Mongration.migrate
  end

  desc 'Returns the version for the most recent migration (i.e. the number of migrations that have been run, not the number of migration files)'
  task version: :environment do
    version = Mongration.version
    puts "Current version: #{version}"
  end

  namespace :migrate do

    desc 'Runs #down on all migration files from the most recent migration'
    task rollback: :environment do
      Mongration.rollback
    end

    desc 'Creates a new migration file in the migration directory'
    task :create, [:name] => [:environment] do |t, args|
      name = args[:name]
      Mongration.create_migration(name)
    end
  end
end
