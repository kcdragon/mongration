module Mongration
  module Migrate
    class Direction

      def initialize(files)
        @files = files
      end

      def perform
        @files.each do |file|
          file.load

          summarize(description_for(file)) do
            migrate(file)
          end

          persist(file)
        end
      end

      private

      def summarize(description)
        Mongration.out.puts("#{description}: #{before_text}")

        begin
          yield
        rescue => e
          Mongration.out.puts("#{e.inspect}: An error has occured, this and all later migrations cancelled")
          raise e
        end

        Mongration.out.puts("#{description}: #{after_text}")
        Mongration.out.puts
      end

      def description_for(file)
        "#{file.version} #{file.class_name}"
      end
    end
  end
end
