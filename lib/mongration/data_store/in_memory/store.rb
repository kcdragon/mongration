module Mongration
  module DataStore
    module InMemory
      class Store

        class Migration < Struct.new(:version, :file_names)
          attr_accessor :destroyed
        end

        def initialize
          @migrations = []
        end

        # @private
        def latest_migration_version
          return 0 if migrations.empty?
          migrations.last.version
        end

        # @private
        def latest_migration_file_names
          return [] if migrations.empty?
          migrations.last.file_names
        end

        # @private
        def migrated_file_names
          migrations.flat_map(&:file_names)
        end

        # @private
        def migrations
          @migrations.reject(&:destroyed)
        end

        # @private
        def store_migration(version, file_names)
          migration = Migration.new(version, file_names)
          @migrations << migration
        end

        # @private
        def remove_migration(version)
          @migrations.detect { |m| m.version == version }.destroyed = true
        end
      end
    end
  end
end
