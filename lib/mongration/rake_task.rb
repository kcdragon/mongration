require 'rake'

namespace :db do
  task :migrate do
    Mongration.migrate
  end

  namespace :migrate do
    task :rollback do
      Mongration.rollback
    end
  end
end
