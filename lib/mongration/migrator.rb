module Mongration

  # @private
  class Migrator

    def initialize(files)
      @files = files
    end

    def perform
      result = Result.success
      @files.each do |file|
        result.merge(file.up)
        break if result.failed?
      end
      result
    end
  end
end
