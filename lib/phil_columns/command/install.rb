require 'fileutils'
require 'pathname'
require 'yaml'


module PhilColumns
  module Command
    class Install < Base

      def execute
        say "Installing phil columns", :cyan
        write "Creating seeds directory: #{seeds_path} ... "
        make_seeds_directory
        say_ok
        write "Writing config file: #{config_file_path} ... "
        write_config_file
        say_ok
      end

    protected

      def make_seeds_directory
        FileUtils.mkdir_p( seeds_path )
      end

      def write_config_file
        config.save_to_file
      end

      def config
        @config = Configuration.new( config_defaults )
      end

      def config_defaults
        defaults = rails? ? rails_default_settings : {}
        defaults.merge(
          seeds_path: seeds_path.to_s,
          default_tags: []
        )
      end

      def seeds_path
        rel = rails? ? 'db/seeds' : options[:seeds_path]
        Pathname.new( rel )
      end

      def rails?
        options[:rails]
      end

      def rails_default_settings
        {
          'env_files' => [
            'config/environment'
          ]
        }
      end

    end
  end
end
