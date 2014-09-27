module PhilColumns
  module WithBackend

    def self.included( base )
      base.class_eval do
        attr_reader :backend
      end
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
