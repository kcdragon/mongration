module Mongration
  class Migration

    # @private
    class Null
      def version
        0
      end

      def up!; end
      def down!; end
    end
  end
end
