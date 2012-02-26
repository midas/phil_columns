module PhilColumns::Command::FilesLikeMatching

  def self.included( base )
    base.class_eval do
      attr_reader :_like, :_to
    private
      attr_writer :_like, :_to
    end
  end

  def like( regex_or_glob_pattern_for_files )
    self._like = regex_or_glob_pattern_for_files
  end

  # A hash of source and dest paths for files to move.
  #
  def files_from_like
    return files_from_like_from_reg_ex if _like.is_a?( Regexp )

    files_from_like_from_glob_pattern
  end
  private :files_from_like

  def files_from_like_from_reg_ex
    files_from_like = {}

    Dir.chdir( base_path ) do
      Dir['*'].each do |file|
        if _like.match( file )
          files_from_like[File.join( base_path, file )] = File.join( base_path, _to, file )
        end
      end
    end

    files_from_like
  end
  private :files_from_like_from_reg_ex

  def files_from_like_from_glob_pattern
    files_from_like = {}

    Dir.chdir( base_path ) do
      Dir.glob( _like ).each do |file|
        files_from_like[File.join( base_path, file )] = File.join( base_path, _to, file )
      end
    end

    files_from_like
  end
  private :files_from_like_from_glob_pattern

end
