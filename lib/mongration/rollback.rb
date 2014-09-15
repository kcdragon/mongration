module Mongration

  # @private
  class Rollback

    def perform
      return unless Migration.exists?
      file = Mongration::File.wrap(Migration.all_file_names).sort.last
      file.down
      Migration.where(file_name: file.file_name).first.destroy
    end
  end
end
