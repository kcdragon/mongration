require 'rake'

namespace :db do
  task migrate: :environment do
    Mongration.migrate
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
