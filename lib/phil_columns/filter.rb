module PhilColumns
  class Filter

    include SeedUtils

    def initialize( config )
      @config      = config
      @seeds_path  = config.seeds_path
      @tags        = config.tags
    end

    def seeds
      load_seeds
      calculate_seed_set
    end

    def calculate_seed_set_all
    end

    def calculate_seed_set_any
      if any_exclusion_tags?
        raise PhilColumns::Error,
              "Cannot provide exclusion tags (#{config.exclusion_tags.join( ', ' )}) when operation is any"
      end

      seeds_for_current_env.tap do |seeds|
        unless tags.empty?
          seeds.select! { |seed_meta| (seed_meta.tags & tags).size > 0 }
        end
      end
    end

  protected

    attr_reader :config,
                :seeds_path,
                :tags

    def calculate_seed_set
      send( "calculate_seed_set_#{config.operation}" ).tap do |seeds|
        unless config.version.blank?
          if config.down
            seeds.select! { |seed_meta| seed_meta.timestamp > config.version }
          else
            seeds.select! { |seed_meta| seed_meta.timestamp <= config.version }
            seeds.reject! { |seed_meta| seed_already_executed?( seed_meta.timestamp ) }
          end
        end

      end
    end

    def any_exclusion_tags?
      config.exclusion_tags.size > 0
    end

  end
end
