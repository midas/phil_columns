require 'pathname'

module PhilColumns
  module Command
    class Seed < Base

      def execute
        load_environment

        say( "- DRY RUN -", :yellow ) if config.dry_run
        say "Seeding #{method_name} to version #{config.version}", :green

        seeds.each do |seed_meta|
          say ''
          say "* Executing seed: #{seed_meta.filepath}", :cyan

          instance = seed_meta.klass.new( config )
          instance.send( method_name )
          record_seed( seed_meta )
        end
      end

    protected

      def record_seed( seed_meta )
        if method_name == :up
          archivist.record_seed( seed_meta.timestamp )
        else
          archivist.remove_seed( seed_meta.timestamp )
        end
      end

      def archivist
        @archivist ||= PhilColumns::Archivist.new
      end

      def seeds
        @seeds ||= filter.seeds
      end

      def filter
        @filter ||= Filter.new( config )
      end

      def load_environment
        return if env_files.nil? || env_files.empty?

        say 'Loading environment ...'

        env_files.each do |file|
          require file.expand_path
        end
      end

      def tags
        config.tags
      end

      def method_name
        return :down if down?
        :up
      end

      def down?
        config.down
      end

      def env_files
        @env_files ||= config.env_files.map { |f| Pathname.new f }
      end

    end
  end
end
