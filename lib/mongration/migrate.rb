module Mongration

  # @private
  class Migrate

    def self.perform
      new.perform
    end

    def perform
      pending_files = File.pending

      if !pending_files.empty?
        pending_files.sort.each do |file|
          file.up
          Migration.create(file_name: file.file_name)
        end
      end
    end
  end
end
