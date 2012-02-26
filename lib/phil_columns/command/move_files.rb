require 'fileutils'

module PhilColumns::Command

  class MoveFiles

    include FilesLikeMatching

    attr_reader :base_path

    def initialize( base_path, &instructions )
      raise 'A block must be provided' unless block_given?
      @base_path = base_path
      self.instance_eval( &instructions )
    end

    def to( path_or_pattern )
      self._to = path_or_pattern
    end

    def execute!
      files_from_like.each do |src, dest|
        FileUtils.mkdir_p File.dirname( dest )
        FileUtils.mv src, dest
      end
    end

  end

end
