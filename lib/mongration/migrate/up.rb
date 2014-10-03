module Mongration
  module Migrate

    # @private
    class Up < Direction

      private

      def migrate(file)
        file.up
      end

      def persist(file)
        Migration.create_by_file_name(file.file_name)
      end

      def before_text
        'migrating'
      end

      def after_text
        'migrated'
      end
    end
  end
end
