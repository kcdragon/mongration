module Mongration
  class Migration
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

      def klass
        file_name.chomp('.rb').gsub(/^\d+_/, '').camelize
      end

      def require_migration
        require(::File.join(Dir.pwd, 'db', 'migrate', file_name))
      end

      def number
        if file_name
          file_name.split('_').first.to_i
        end
      end
    end
  end
end
