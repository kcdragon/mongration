module Mongration
  module Migrate
    autoload :Direction, 'mongration/migrate/direction'
    autoload :Down,      'mongration/migrate/down'
    autoload :Up,        'mongration/migrate/up'
  end
end
