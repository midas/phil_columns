module PhilColumns
  module Command
    class Empty < Base

      def execute
        load_environment
        purger.purge
      end

    protected

      def purger
        @purger ||= PhilColumns::Purger.new( config )
      end

    end
  end
end
