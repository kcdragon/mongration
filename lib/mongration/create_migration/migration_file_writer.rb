module Mongration
  class CreateMigration

    # @private
    class MigrationFileWriter

      def self.write(file_name, options = {})
        new(file_name, options).write
      end

      def initialize(file_name, options = {})
        @file_name = file_name
        @up = options[:up]
        @down = options[:down]
      end

      def write
        ::File.open(::File.join(Mongration.configuration.dir, @file_name), 'w') do |file|
          file.write(<<EOS
class #{class_name}
  def self.up
    #{@up}
  end

  def self.down
    #{@down}
  end
end
EOS
          )
        end
      end

      private

      def class_name
        File.new(@file_name).class_name
      end
    end
  end
end
