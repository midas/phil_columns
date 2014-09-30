module PhilColumns
  class Seed

    def self.depends_on( *depends_on )
      self._depends_on += depends_on.sort.map( &:to_s )
    end

    def self.env( *envs )
      self.envs( *envs )
    end

    def self.envs( *envs )
      self._envs += envs.sort.map( &:to_s )
    end

    def self.tag( *tags )
      self.tags( *tags )
    end

    def self.tags( *tags )
      self._tags += tags.sort.map( &:to_s )
    end

    def initialize( config )
      @config = config
    end

  protected

    attr_reader :config

    def dry_run?
      config.dry_run
    end

    def protect( &block )
      block.call unless dry_run?
    end

    def self._envs
      @_envs || []
    end

    def self._tags
      @_tags || []
    end

    def self._depends_on
      @_depends_on || []
    end

    def self._envs=( val )
      @_envs = val
    end

    def self._tags=( val )
      @_tags = val
    end

    def self._depends_on=( val )
      @_depends_on = val
    end

  end
end
