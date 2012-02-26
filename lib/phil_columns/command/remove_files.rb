module PhilColumns::Command

  class RemoveFiles

    include BasePathedCommand
    include FilesLikeMatching

    def initialize( base_path, &instructions )
      raise 'A block must be provided' unless block_given?
      @base_path = base_path
      self.instance_eval( &instructions )
    end

    def execute!
      files_to_remove.each do |file|
        FileUtils.rm file
      end
    end

    def files_to_remove
      files_from_like
    end

  end

end
