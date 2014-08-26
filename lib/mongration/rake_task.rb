require 'rake'

namespace :db do
  task :migrate do
    Mongration.migrate
  end

  namespace :migrate do
    task :rollback do
      Mongration.rollback
    end

    task :create, [:name] do |t, args|
      name = args[:name]
      Mongration.create_migration(name)
    end
  end
end
