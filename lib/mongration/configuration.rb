module Mongration

  # @private
  class Configuration

    class ConfigNotFound < Errors
      def initialize(path)
        super("#{path} cannot be found.")
      end
    end

    attr_reader :dir, :config_path
    attr_writer :err_out, :timestamps, :silent

    def dir=(dir)
      unless ::File.exists?(dir)
        print_warning("Migration Directory #{dir} does not exists.")
      end

      @dir = dir
    end

    def config_path=(config_path)
      unless ::File.exists?(config_path)
        raise ConfigNotFound.new(config_path)
      end

      env = if defined?(Rails)
              Rails.env
            else
              :test
            end
      Mongoid.load!(config_path, env)
    end

    def timestamps?
      @timestamps
    end

    def silent?
      @silent
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
