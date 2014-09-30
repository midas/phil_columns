require 'hashie'
require 'pathname'
require 'yaml'

module PhilColumns
  class Configuration < SimpleDelegator

    TAG_REGEX = /^~@?(\w+)$/

    def initialize( options={} )
      @_config = Hashie::Mash.new( read_config_file ).
                              merge( options )

      super( _config )
    end

    def tags
      (_config[:tags].nil? || _config[:tags].empty?) ?
        _config.default_tags :
        _config.tags
    end

    def partitioned_tags
      @partitioned_tags ||= tags.partition { |tag| TAG_REGEX.match( tag ) }
    end

    def exclusion_tags
      partitioned_tags.first.
                       map { |tag| TAG_REGEX.match( tag )[1] }
    end

    def inclusion_tags
      partitioned_tags.last
    end

    def config_filepath
      Pathname.new( '.phil_columns' )
    end

    # Not sure why we need these explicit proxies
    def down;      _config.down;      end
    def dry_run;   _config.dry_run;   end
    def operation; _config.operation; end

    def version
      if _config.down &&
          _config.version == 'all'
        '0'
      else
        _config.version
      end
    end

    def slice( *keys )
      Hashie::Mash.new( _config.select { |k,v| keys.map( &:to_s ).include?( k.to_s ) } )
    end

    def save_to_file
      File.open( config_filepath, 'w' ) do |f|
        f.write( YAML::dump( config_as_hash ))
      end
    end

  protected

    attr_reader :_config

    def read_config_file
      return {} unless config_filepath.file?
      YAML::load_file( config_filepath.expand_path )
    end

    def config_as_hash
      slice( *keys_to_persist ).to_h
    end

    def keys_to_persist
      %w(
        default_tags
        env_files
        schema_load_strategy
        schema_unload_strategy
        seeds_path
        skip_tables_on_empty
      )
    end

  end
end
