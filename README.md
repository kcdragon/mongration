# Mongration

[![Build Status](https://travis-ci.org/kcdragon/mongration.svg?branch=master)](https://travis-ci.org/kcdragon/mongration)
[![Code Climate](https://codeclimate.com/github/kcdragon/mongration/badges/gpa.svg)](https://codeclimate.com/github/kcdragon/mongration)

Mongration is a tool for migrating data. It is designed to have the same interface as [ActiveRecord](https://github.com/rails/rails/tree/master/activerecord)'s migrations but be used with [Mongoid](https://github.com/mongoid/mongoid) instead of a SQL database.

Currently, there are only two supported Rake tasks, `db:migrate` and `db:migrate:rollback`. It only supports the numeric-based file names ("001_add_foo_to_bar.rb") and not the date-based file names ("20140101_add_foo_to_bar.rb").

There are no generators; creating the migration file is left to the developer.

## Installation

Add this line to your application's Gemfile:

    gem 'mongration'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongration

## Usage

The primary usage will be through the Rake tasks `db:migrate` and `db:migrate:rollback`.

The migrate and rollback functionality can be accessed programmatically via `Mongration.migrate` and `Mongration.rollback`.

Migration files have the following structure:

    class AddFoo
      def self.up
      end

      def self.down
      end
    end

The above must have a file name of 'XXX_add_foo.rb' where XXX is a number.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/mongration/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
