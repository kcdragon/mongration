module Mongration

  # @private
  class Configuration
    attr_reader :dir
    attr_writer :err_out

    def dir=(dir)
      unless File.exists?(dir)
        print_warning("Migration Directory #{dir} does not exists.")
      end

      @dir = dir
    end

    def mongoid_config_path=(path)
      env = if defined?(Rails)
              Rails.env
            else
              :test
            end
      Mongoid.load!(path, env)
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
