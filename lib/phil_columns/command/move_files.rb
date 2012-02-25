require 'fileutils'

module PhilColumns::Command

  class MoveFiles

    attr_reader :base_path, :_like, :_to

    def initialize( base_path, &instructions )
      raise 'A block must be provided' unless block_given?
      @base_path = base_path
      self.instance_eval( &instructions )
    end

    def like( regex_or_glob_pattern_for_files )
      self._like = regex_or_glob_pattern_for_files
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

    attr_writer :_like, :_to

    # A hash of source and dest paths for files to move.
    #
    def files_to_move
      return files_to_move_from_reg_ex if _like.is_a?( Regexp )

      files_to_move_from_glob_pattern
    end

    def files_to_move_from_reg_ex
      files_to_move = {}

      Dir.chdir( base_path ) do
        Dir['*'].each do |file|
          if _like.match( file )
            files_to_move[File.join( base_path, file )] = File.join( base_path, _to, file )
          end
        end
      end

      files_to_move
    end

    def files_to_move_from_glob_pattern
      files_to_move = {}

      Dir.chdir( base_path ) do
        Dir.glob( _like ).each do |file|
          files_to_move[File.join( base_path, file )] = File.join( base_path, _to, file )
        end
      end

      files_to_move
    end

  end

end
