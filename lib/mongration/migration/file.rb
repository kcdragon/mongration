module Mongration
  class Migration

    # @private
    class File
      include Mongoid::Document

      field :file_name, type: String

      embedded_in :migration, class_name: 'Mongration::Migration'

      def up
        require_migration
        klass.constantize.up
      end

      def down
        require_migration
        klass.constantize.down
      end

      def number
        if file_name
          file_name.split('_').first.to_i
        end
      end

      private

      def klass
        file_name.chomp('.rb').gsub(/^\d+_/, '').camelize
      end

      def require_migration
        dir = Mongration.configuration.dir
        require(::File.join(Dir.pwd, dir, file_name))
      end
    end
  end
end
