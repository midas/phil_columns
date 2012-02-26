module PhilColumns
  module Command

    autoload :BasePathedCommand, "#{File.dirname __FILE__}/command/base_pathed_command"
    autoload :ConvertFiles,      "#{File.dirname __FILE__}/command/convert_files"
    autoload :FilesLikeMatching, "#{File.dirname __FILE__}/command/files_like_matching"
    autoload :RemoveFiles,       "#{File.dirname __FILE__}/command/remove_files"
    autoload :MoveFiles,         "#{File.dirname __FILE__}/command/move_files"

  end
end
