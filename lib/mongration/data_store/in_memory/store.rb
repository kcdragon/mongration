module Mongration
  module DataStore
    module InMemory
      class Store

        class Migration < Struct.new(:version, :file_names)
          attr_reader :destroyed

          def save; end

          def destroy
            @destroyed = true
          end
        end

        def initialize
          @migrations = []
        end

        def migrations
          @migrations.reject(&:destroyed)
        end

        def build_migration(version, file_names)
          migration = Migration.new(version, file_names)
          @migrations << migration
          migration
        end
      end
    end
  end
end
