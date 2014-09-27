module PhilColumns
  class Migrator

    include PhilColumns::Output
    include PhilColumns::WithBackend

    def initialize( config )
      @backend = PhilColumns::migrator_klass.new
      @config  = config
    end

    def clear_migrations_table
      raise( *error ) unless backend_responds?( :clear_migrations_table )
      backend.send :clear_migrations_table
    end

    def down( version=0 )
      raise( *error ) unless backend_responds?( :down )
      backend.send :down, version
    end

    def drop_table( table )
      raise( *error ) unless backend_responds?( :drop_table )
      backend.send :drop_table, table
    end

    def drop_tables
      raise( *error ) unless backend_responds?( :drop_tables )
      backend.send :drop_tables
    end

    def latest_version
      raise( *error ) unless backend_responds?( :latest_version )
      backend.send :latest_version
    end

    def load_schema
      raise( *error ) unless backend_responds?( :load_schema )
      backend.send :load_schema
    end

    def mulligan
      if config.schema_unload_strategy == 'drop'
        confirm "Dropping all tables ... ", :cyan do
          drop_tables
          clear_migrations_table
        end
      else
        confirm "Migrating DB to version 0 ... ", :cyan do
          down
        end
      end

      if config.schema_load_strategy == 'load'
        confirm "Loading schema ... ", :cyan do
          load_schema
        end
      else
        confirm "Migrating DB to latest version ... ", :cyan do
          up
        end
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

    attr_reader :config

  end
end
