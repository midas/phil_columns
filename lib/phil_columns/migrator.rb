module PhilColumns
  class Migrator

    include PhilColumns::Output
    include PhilColumns::WithBackend

    def initialize
      @backend = PhilColumns::migrator_klass.new
    end

    def down( version=0 )
      raise( *error ) unless backend_responds?( :down )
      backend.send :down, version
    end

    def latest_version
      raise( *error ) unless backend_responds?( :latest_version )
      backend.send :latest_version
    end

    def mulligan
      confirm "Migrating DB to version 0 ... ", :cyan do
        down
      end

      confirm "Migrating DB to latest version ... ", :cyan do
        up
      end
    end

    def tables
      raise( *error ) unless backend_responds?( :tables )
      backend.send :tables
    end

    def up( version=nil )
      raise( *error ) unless backend_responds?( :up )
      backend.send :up, version
    end

  protected

    def backend_responds?( method )
      backend && backend.respond_to?( method )
    end

    def error
      [NotImplementedError, "You must include a database adapter (ie. phil_columns-activerecord)"]
    end

  end
end
