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

      def config
        @config = Configuration.new( options )
      end

      def config_file_path
        '.phil_columns'
      end

      def base_path
        Pathname.new( Dir.pwd )
      end

    end
  end
end
