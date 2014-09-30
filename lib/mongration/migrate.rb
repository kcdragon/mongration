module Mongration
  module Migrate
    autoload :Direction, 'mongration/migrate/direction'
    autoload :Down,      'mongration/migrate/down'
    autoload :Summary,   'mongration/migrate/summary'
    autoload :Up,        'mongration/migrate/up'
  end
end
