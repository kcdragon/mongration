require 'rake'

namespace :db do
  task migrate: :environment do
    Mongration.migrate
  end

  task version: :environment do
    version = Mongration.version
    puts "Current version: #{version}"
  end

  namespace :migrate do
    task rollback: :environment do
      Mongration.rollback
    end

    task :create, [:name] => [:environment] do |t, args|
      name = args[:name]
      Mongration.create_migration(name)
    end
  end
end
