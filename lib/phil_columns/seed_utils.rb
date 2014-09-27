module PhilColumns
  module SeedUtils

    SEED_REGEX =  /^\w+\/\w+\/(\d{14})_(.+)\.rb$/

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

    def seeds_for_current_env
      map_seeds.select { |seed_meta| seed_meta.envs.include?( config.env ) }
    end

    def each_seed_meta_for_current_env( &block )
      seeds_for_current_env.each do |seed_meta|
        block.call( seed_meta )
      end
    end

    def seeds_path
      config.seeds_path
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
