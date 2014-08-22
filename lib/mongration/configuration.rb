module Mongration

  # @private
  class Configuration
    attr_reader :dir
    attr_writer :err_out
    attr_accessor :data_store

    def dir=(dir)
      unless ::File.exists?(dir)
        print_warning("Migration Directory #{dir} does not exists.")
      end

      @dir = dir
    end

    private

    def print_warning(message)
      err_out.puts("Warning: #{message}")
    end

    def err_out
      @err_out || $stderr
    end
  end
end
