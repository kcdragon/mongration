module Mongration
  class Migration
    class Null
      def version
        0
      end

      def up!; end
      def down!; end
    end
  end
end
