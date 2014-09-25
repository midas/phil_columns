module PhilColumns
  module Command
    class Base

      include Thor::Actions

      def initialize( options )
        @options = options
      end

      def execute
        raise NotImplementedError, "You must implement #{self.class.name}#execute"
      end

    protected

      attr_reader :options

      def config
        @config = Configuration.new( options )
      end

      def config_file_path
        '.phil_columns'
      end

      def base_path
        Pathname.new( Dir.pwd )
      end

      def write( msg, color=:white )
        $stdout.write( Rainbow( msg ).color( color ))
      end

      def say( msg, color=:white )
        $stdout.puts( Rainbow( msg ).color( color ))
      end

      def say_ok
        say 'OK', :green
      end

      def say_error
        say 'ERROR', :red
      end

    end
  end
end
