module Mongration
  module Migrate
    class Direction

      def initialize(files)
        @files = files
      end

      def perform
        @files.each do |file|
          file.load
          migrate_with_summary(file)
          persist(file)
        end
      end

      private

      def migrate_with_summary(file)
        direction = self.class.to_s.split('::').last.downcase.to_sym
        Migrate::Summary.new(file).for(direction) do
          migrate(file)
        end
      end
    end
  end
end
