module Mongration
  module DataStore
    module Mongoid
      class Store
        def initialize(options = {})
          path = options[:config_path]
          env = if defined?(Rails)
                  Rails.env
                else
                  :test
                end
          ::Mongoid.load!(path, env)
        end

        # @private
        def migrations
          Migration.all
        end

        # @private
        def build_migration(version, file_names)
          Migration.build(version, file_names)
        end
      end
    end
  end
end
