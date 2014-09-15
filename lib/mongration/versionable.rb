module Mongration

  # @private
  module Versionable
    include Comparable

    def version
      file_name.split('_').first
    end

    def number
      version.to_i
    end

    def <=>(other)
      number <=> other.number
    end
  end
end
