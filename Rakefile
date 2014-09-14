require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false

  require 'os_check'
  if OsCheck.mac_osx?
    t.rspec_opts = '--format Nc'
  end
end

require 'tailor/rake_task'
Tailor::RakeTask.new

task :default => [:spec, :tailor]
