module Mongration
  module Migrate
    class Summary

      def initialize(file)
        @file = file
      end

      def for(direction)
        description = "#{@file.version} #{@file.class_name}"

        before, after = nil, nil
        case direction
        when :up
          before, after = 'migrating', 'migrated'
        when :down
          before, after = 'reverting', 'reverted'
        end

        Mongration.out.puts("#{description}: #{before}")

        begin
          yield
        rescue => e
          Mongration.out.puts("#{e.inspect}: An error has occured, this and all later migrations cancelled")
          raise e
        end

        Mongration.out.puts("#{description}: #{after}")
        Mongration.out.puts
      end
    end
  end
end
