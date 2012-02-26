module PhilColumns::Command

  class MoveFiles

    include BasePathedCommand
    include FilesLikeMatching

    attr_reader :_to

    def initialize( base_path, &instructions )
      raise 'A block must be provided' unless block_given?
      @base_path = base_path
      self.instance_eval( &instructions )
    end

    def to( path_or_pattern )
      self._to = path_or_pattern
    end

    def execute!
      files_to_move.each do |src, dest|
        FileUtils.mkdir_p File.dirname( dest )
        FileUtils.mv src, dest
      end
    end

  private

    attr_writer :_to

    # A hash of source and dest paths for files to move.
    #
    def files_to_move
      Hash[files_from_like.map { |f| [f, File.join( File.dirname( f ), _to, File.basename( f ) )] }]
    end
    private :files_to_move

  end

end
