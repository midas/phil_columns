require 'pathname'

module PhilColumns
  module Command
    class Mulligan < Base

      def execute
        load_environment

        say( "- DRY RUN -", :yellow ) if dry_run?
        migrator.mulligan unless dry_run?
        seeder.execute
      end

    protected

      def migrator
        @migrator ||= PhilColumns::Migrator.new
      end

      def seeder
        @seeder ||= PhilColumns::Seeder.new( config )
      end

      def load_environment
        return if env_files.nil? || env_files.empty?

        say 'Loading environment ...'

        env_files.each do |file|
          require file.expand_path
        end
      end

      def dry_run?
        config.dry_run
      end

      def env_files
        @env_files ||= config.env_files.map { |f| Pathname.new f }
      end

    end
  end
end
