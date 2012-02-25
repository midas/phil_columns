module PhilColumns

  class Recipe

    attr_reader :instructions,
                :recipe_file_path

    def initialize( recipe_file_path, base_path=nil )
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

    def move_files( &block )
      Command::MoveFiles.new( base_path,
                              &block ).execute!
    end

    def execute!
      self.instance_eval( instructions,
                          recipe_file_path )
    end

  end

end
