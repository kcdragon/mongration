source 'https://rubygems.org'

group :test do
  gem 'guard-rspec', '4.3.1', require: false
end

# debuggers
gem 'ruby-debug', platforms: :jruby
gem 'debugger',   platforms: :mri_19
gem 'byebug',     platforms: [:mri_20, :mri_21]

require './lib/os_check.rb'
if OsCheck.mac_osx?
  gem 'rspec-nc'
end

gemspec
