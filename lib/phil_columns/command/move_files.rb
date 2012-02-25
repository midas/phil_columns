module PhilColumns::Command

  class MoveFiles

     def like( regex_or_glob_pattern_for_files )
       like = regex_or_glob_pattern_for_files
     end
     attr_reader :like

  private

    def like=( val )
      @like = val
    end

  end

end
