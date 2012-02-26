module PhilColumns

  class Recipe

    attr_reader :instructions,
                :recipe_file_path

    def initialize( recipe_file_path, base_path=nil )
      raise 'Please provide a recipe file path' if recipe_file_path.nil?
      raise 'Recipe file does not exist' unless File.file?( recipe_file_path )

      @recipe_file_path     = recipe_file_path
      @overridden_base_path = base_path
      @instructions         = File.read( recipe_file_path )
    end

    def base_path
      @overridden_base_path || @base_path
    end

    def set_base_path( path )
      @base_path = path
    end

    def execute!
      self.instance_eval( instructions,
                          recipe_file_path )
    end

    # --------------------------------------------
    # Built in commands
    # --------------------------------------------

    # Move files from a source to a destination.  Currently supports relative destinations
    # to base path.
    #
    def move_files( &block )
      Command::MoveFiles.new( base_path,
                              &block ).execute!
    end

    # Remove files matching a Regexp or directory glob pattern.
    #
    def remove_files( &block )
      Command::RemoveFiles.new( base_path,
                                &block ).execute!
    end

  end

end
