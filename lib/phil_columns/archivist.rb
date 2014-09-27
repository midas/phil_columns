module PhilColumns
  class Archivist

    attr_reader :backend

    def initialize
      @backend = PhilColumns::archivist_klass.new
    end

    def clear_seeds
      raise( *error ) unless backend_responds?( :clear_seeds )
      backend.send :clear_seeds
    end

    def record_seed( version )
      raise( *error ) unless backend_responds?( :record_seed )
      backend.send :record_seed, version
    end

    def remove_seed( version )
      raise( *error ) unless backend_responds?( :remove_seed )
      backend.send :remove_seed, version
    end

    def seed_already_executed?( version )
      raise( *error ) unless backend_responds?( :seed_already_executed? )
      backend.send :seed_already_executed?, version
    end

    def ensure_schema_seeds_table!
      raise( *error ) unless backend_responds?( :ensure_schema_seeds_table! )
      backend.send :ensure_schema_seeds_table!
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
