module PhilColumns
  class Filter

    SEED_REGEX =  /^\w+\/\w+\/(\d{14})_(.+)\.rb$/

    def initialize( config )
      @config      = config
      @current_env = config.env
      @seeds_path  = config.seeds_path
      @tags        = config.tags
    end

    def seeds
      load_seeds
      calculate_seed_set
    end

  protected

    attr_reader :config,
                :current_env,
                :seeds_path,
                :tags

    def calculate_seed_set
      send( "calculate_seed_set_#{config.operation}" ).tap do |seeds|
        unless config.version.blank?
          if config.down
            seeds.select! { |seed_meta| seed_meta.timestamp > config.version }
            # TODO: reject if not already run
          else
            seeds.select! { |seed_meta| seed_meta.timestamp <= config.version }
            seeds.reject! { |seed_meta| seed_already_executed?( seed_meta.timestamp ) }
          end
        end

      end
    end

    def calculate_seed_set_all
    end

    def calculate_seed_set_any
      if any_exclusion_tags?
        raise PhilColumns::Error,
              "Cannot provide exclusion tags (#{config.exclusion_tags.join( ', ' )}) when operation is any"
      end

      map_seeds.select { |seed_meta| seed_meta.envs.include?( current_env ) }.tap do |seeds|
        unless tags.empty?
          seeds.select! { |seed_meta| (seed_meta.tags & tags).size > 0 }
        end
      end
    end

    def seed_already_executed?( version )
      archivist.seed_already_executed?( version )
    end

    def archivist
      @archivist ||= PhilColumns::Archivist.new
    end

    def any_exclusion_tags?
      config.exclusion_tags.size > 0
    end

    def load_seeds
      seed_filepaths.each do |seed_filepath|
        load seed_filepath
      end
    end

    def map_seeds
      seed_filepaths.map do |seed_filepath|
        klass = discover_seed_class( seed_filepath )

        Hashie::Mash.new( envs: klass._envs,
                          filepath: seed_filepath,
                          klass: klass,
                          tags: klass._tags,
                          timestamp: discover_seed_timestamp( seed_filepath ))
      end
    end

    def seed_filepaths
      seeds = Dir.glob( "#{seeds_path}/*" )
      if config.down
        seeds.sort { |a,b| b <=> a }
      else
        seeds.sort
      end
    end

    def discover_seed_timestamp( filepath )
      matches = SEED_REGEX.match( filepath )
      matches[1]
    end

    def discover_seed_class( filepath )
      matches = SEED_REGEX.match( filepath )
      snakecased = matches[2]
      snakecased.camelize.constantize
    end

  end
end
