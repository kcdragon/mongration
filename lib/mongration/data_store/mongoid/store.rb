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
        def latest_migration_version
          return 0 if latest_migration.nil?
          latest_migration.version
        end

        # @private
        def latest_migration_file_names
          return [] if latest_migration.nil?
          latest_migration.file_names
        end

        # @private
        def migrated_file_names
          Migration.all.pluck(:file_names).flatten
        end

        # @private
        def store_migration(version, file_names)
          Migration.create(version: version, file_names: file_names)
        end

        # @private
        def remove_migration(version)
          migration = Migration.where(version: version).first
          if migration
            migration.destroy
          end
        end

        private

        def latest_migration
          Migration.desc(:version).first
        end

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
