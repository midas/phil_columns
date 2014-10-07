module PhilColumns
  module Command
    class Console < Base

      def execute
        load_environment
        load_seed_helpers
        start_console
      end

    protected

      def start_console
        require 'irb'
        IRB.start
      end

      def load_seed_helpers
        if defined?( Seeds )
          Seeds::constants.each do |const_name|
            konstant = Seeds::const_get(const_name)
            Object.send( :include, konstant )
          end
        end
      end

    end
  end
end
