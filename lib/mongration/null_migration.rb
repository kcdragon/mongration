module Mongration

  # @private
  class NullMigration
    def version
      0
    end

    def file_names
      []
    end

    def save; end
    def destroy; end
  end
end
