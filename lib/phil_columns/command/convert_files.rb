module PhilColumns::Command

  class ConvertFiles

    include BasePathedCommand
    include FilesLikeMatching

    def initialize( base_path, &instructions )
      raise 'A block must be provided' unless block_given?
      @base_path = base_path
      self.instance_eval( &instructions )
    end

  end

end
