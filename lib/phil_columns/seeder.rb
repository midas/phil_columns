module PhilColumns
  class Seeder

    include PhilColumns::Output
    include PhilColumns::SeedUtils

    def initialize( config )
      @config = config
    end

    def execute
      seeds.each do |seed_meta|
        confirm "Executing seed: #{seed_meta.name} ... ", :cyan do
          unless dependencies_satisfied?( seed_meta.klass.depends_on )
            raise PhilColumns::Error, failed_dependencies_message( seed_meta )
          end

          instance = seed_meta.klass.new( config )
          instance.send( method_name )
          record_seed( seed_meta )
        end
      end
    end

  protected

    attr_reader :config,
                :unsatisfieds

    def record_seed( seed_meta )
      if method_name == :up
        archivist.record_seed( seed_meta.timestamp )
      else
        archivist.remove_seed( seed_meta.timestamp )
      end
    end

    def dependencies_satisfied?( dependencies )
      @unsatisfieds = dependencies.select { |version| !seed_already_executed?( version ) }
      unsatisfieds.blank?
    end

    def seeds
      @seeds ||= filter.seeds
    end

    def filter
      @filter ||= Filter.new( config )
    end

    def method_name
      return :down if down?
      :up
    end

    def down?
      config.down
    end

    def failed_dependencies_message( seed_meta )
      "Cannot execute seed #{seed_meta.name} due to unsatisfied dependencies: #{unsatisfieds.join ', '}.  Please adjust " +
        "the specified tags (#{config.tags.join ', '}) to resolve the failed dependencies."
    end

  end
end
