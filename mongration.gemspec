# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongration/version'

Gem::Specification.new do |spec|
  spec.name          = "mongration"
  spec.version       = Mongration::VERSION
  spec.authors       = ["Mike Dalton"]
  spec.email         = ["michaelcdalton@gmail.com"]
  spec.summary       = %q{Migrations for Mongoid}
  spec.description   = %q{Mongration is a tool for migrating data. It is designed to have the same interface as ActiveRecord's migrations but be used with Mongoid instead of a SQL database.}
  spec.homepage      = "https://github.com/kcdragon/mongration"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "mongoid", ">= 3.0"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "= 3.0"
end
