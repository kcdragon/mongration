module Mongration

  # @private
  class Migrate

    def perform
      File.pending.each do |file|
        file.up
        Migration.create_by_file_name(file.file_name)
      end
    end
  end
end
