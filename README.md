# Mongration [![Build Status](https://travis-ci.org/kcdragon/mongration.svg?branch=master)](https://travis-ci.org/kcdragon/mongration) [![Code Climate](https://codeclimate.com/github/kcdragon/mongration/badges/gpa.svg)](https://codeclimate.com/github/kcdragon/mongration) [![Coverage Status](https://coveralls.io/repos/kcdragon/mongration/badge.png)](https://coveralls.io/r/kcdragon/mongration)

**ActiveRecord-like Migrations for Mongoid**

Mongration is a tool for migrating data. It is designed to have the same interface as [ActiveRecord](https://github.com/rails/rails/tree/master/activerecord)'s migrations but be used with [Mongoid](https://github.com/mongoid/mongoid) instead of an SQL database.

Mongration supports the following rake tasks:
* `db:migrate` - migrates all pending migrations
* `db:rollback` - rolls back the most recent migration
* `db:version` - outputs the numeric identifier for the most migration
* `db:migrate:create` - takes the place of the `rails generate migration` generator
* `db:migrate:status` - outputs a table of all files and their migration status

## Support

The following versions of Ruby are supported:

* MRI 2.1
* MRI 2.0
* MRI 1.9.3
* JRuby 1.9

## Installation

Add this line to your application's Gemfile:

    gem 'mongration'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongration --pre

## Usage

The primary usage will be through the Rake tasks `db:migrate` and `db:rollback`. Migrate will run all migrations that have not been run before. Rollback will rollback the previous migration.

Migration files have the following structure:

    class AddFoo
      def self.up
      end

      def self.down
      end
    end

The above file could be created with `bundle exec rake db:migrate:create[AddFoo]` or `bundle exec rake db:migrate:create[add_foo]`.

## Contributing

Contributions are welcome. Please make sure you write a test for any new features or bugs.

1. Fork it ( https://github.com/[my-github-username]/mongration/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
