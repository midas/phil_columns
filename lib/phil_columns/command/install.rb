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
        confirm "Writing env file: #{env_file_path} ... " do
          write_env_file
        end
      end

    protected

      def make_seeds_directory
        FileUtils.mkdir_p( seeds_path )
      end

      def write_config_file
        config.save_to_file
      end

      def write_env_file
        File.open env_file_path.expand_path, 'w' do |f|
          f.puts( '# Add any Phil Columns only configuration in this file' )
        end
      end

      def config
        @config = Configuration.new( config_defaults )
      end

      def config_defaults
        defaults = rails? ? rails_default_settings : {}
        defaults.merge(
          default_tags: [
            'default'
          ],
          schema_load_strategy: 'load',
          schema_unload_strategy: 'drop',
          seeds_path: seeds_path.to_s,
          skip_tables_on_empty: []
        )
      end

      def seeds_path
        rel = rails? ? 'db/seeds' : options[:seeds_path]
        Pathname.new( rel )
      end

      def env_file_path
        Pathname.new( 'config/phil_columns.rb' )
      end

      def rails?
        options[:rails]
      end

      def rails_default_settings
        {
          env_files: [
            'config/environment',
            'config/phil_columns'
          ]
        }
      end

    end
  end
end
