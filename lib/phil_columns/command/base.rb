module PhilColumns
  module Command
    class Base

      include Thor::Actions
      include PhilColumns::Output

      def initialize( options )
        @options = options
      end

      def execute
        raise NotImplementedError, "You must implement #{self.class.name}#execute"
      end

    protected

      attr_reader :options

      def archivist
        @archivist ||= PhilColumns::Archivist.new
      end

      def migrator
        @migrator ||= PhilColumns::Migrator.new( config )
      end

      def seeder
        @seeder ||= PhilColumns::Seeder.new( config )
      end

      def dry_run?
        config.dry_run
      end

      def config
        @config = Configuration.new( options )
      end

      def config_file_path
        '.phil_columns'
      end

      def base_path
        Pathname.new( Dir.pwd )
      end

      def load_environment
        return if env_files.nil? || env_files.empty?

        env_files.each do |file|
          say "Loading environment: #{file} ..."
          require file.expand_path
        end
      end

      def env_files
        @env_files ||= config.env_files.map { |f| Pathname.new f }
      end

    end
  end
end
