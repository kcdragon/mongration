module Mongration
  class Migrations
    include Mongoid::Document

    field :version, type: Integer, default: 0

    def self.version
      current.version
    end

    def self.increment
      current.increment
    end

    def self.decrement
      current.decrement
    end

    def self.current
      first || create!
    end

    def increment
      inc(:version, 1)
    end

    def decrement
      if version <= 0
        update_attribute(:version, 0)
        0
      else
        inc(:version, -1)
      end
    end
  end
end
