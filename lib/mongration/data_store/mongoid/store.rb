require 'mongoid'

require 'mongration/data_store/mongoid/migration'

module Mongration
  module DataStore
    module Mongoid
      class Store

        class Mongration::DataStore::Mongoid::ConfigNotFound < ::Mongration::Errors
          def initialize(path)
            super("#{path} cannot be found.")
          end
        end

        DEFAULT_CONFIG_PATH = ::File.join('config', 'mongoid.yml')

        # @params [Hash] options
        #
        def initialize(options = {})
          @config_path = options[:config_path] || DEFAULT_CONFIG_PATH

          load_configuration
        end

        # @private
        def migrations
          Migration.all
        end

        # @private
        def build_migration(version, file_names)
          Migration.new(version: version, file_names: file_names)
        end

        private

        def load_configuration
          unless ::File.exists?(@config_path)
            raise Mongration::DataStore::Mongoid::ConfigNotFound.new(@config_path)
          end

          env = if defined?(Rails)
                  Rails.env
                else
                  :test
                end
          ::Mongoid.load!(@config_path, env)
        end
      end
    end
  end
end
