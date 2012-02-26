module PhilColumns
  module Command

    autoload :FilesLikeMatching, "#{File.dirname __FILE__}/command/files_like_matching"
    autoload :RemoveFiles,       "#{File.dirname __FILE__}/command/remove_files"
    autoload :MoveFiles,         "#{File.dirname __FILE__}/command/move_files"

  end
end
