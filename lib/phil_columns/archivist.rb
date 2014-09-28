module PhilColumns
  class Archivist

    include PhilColumns::WithBackend

    def initialize
      @backend = PhilColumns::archivist_klass.new
    end

    def clear_seeds
      ensure_schema_seeds_table!
      raise( *error ) unless backend_responds?( :clear_seeds )
      backend.send :clear_seeds
    end

    def record_seed( version )
      ensure_schema_seeds_table!
      raise( *error ) unless backend_responds?( :record_seed )
      backend.send :record_seed, version
    end

    def remove_seed( version )
      ensure_schema_seeds_table!
      raise( *error ) unless backend_responds?( :remove_seed )
      backend.send :remove_seed, version
    end

    def seed_already_executed?( version )
      ensure_schema_seeds_table!
      raise( *error ) unless backend_responds?( :seed_already_executed? )
      backend.send :seed_already_executed?, version
    end

    def ensure_schema_seeds_table!
      raise( *error ) unless backend_responds?( :ensure_schema_seeds_table! )
      backend.send :ensure_schema_seeds_table!
    end

  end
end
