require 'fileutils'
require 'pathname'
require 'yaml'


module PhilColumns
  module Command
    class Install < Base

      def execute
        say "Installing phil columns", :cyan

        confirm "Creating seeds directory: #{seeds_path} ... " do
          make_seeds_directory
        end

        begin
          write "Writing config file: #{config_file_path} ... "
          write_config_file
          say_ok
        rescue PhilColumns::Error
          say_skipping
        end

        begin
          write "Writing env file: #{env_file_path} ... "
          write_env_file
          say_ok
        rescue PhilColumns::Error
          say_skipping
        end
      end

    protected

      def make_seeds_directory
        FileUtils.mkdir_p( seeds_path )
      end

      def write_config_file
        if file_collision( config.config_filepath )
          config.save_to_file
          return
        end

        raise PhilColumns::Error, "Config file #{config.config_filepath} already exists"
      end

      def write_env_file
        if file_collision( env_file_path.expand_path )
          File.open env_file_path.expand_path, 'w' do |f|
            f.puts( "# Add any Phil Columns only configuration in this file\n\nActiveRecord::Base::connection # need this for console command (not sure why?)\n" )
          end

          return
        end

        raise PhilColumns::Error, "Config file #{env_file_path.expand_path} already exists"
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
          skip_tables_on_purge: []
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
