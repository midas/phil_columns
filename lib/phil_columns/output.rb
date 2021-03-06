module PhilColumns
  module Output

    def self.included( base )
      base.send( :include, Thor::Shell )
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

    def say_skipping
      say 'SKIPPING', :yellow
    end

    def confirm( msg, color=:white, &block )
      write msg, color
      block.call
      say_ok
    rescue
      say_error
      raise
    end
  end
end
