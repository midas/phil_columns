module FileArtifactSpecHelper

  def touch_test_file( file_path=nil )
    file_path ||= default_test_file_path
    ensure_test_environment
    FileUtils.touch file_path
  end

  def touch_test_files( number_of_files=2 )
    (1..number_of_files).each do |num|
      touch_test_file File.join( temp_path, "test_file_#{num}.txt" )
    end
  end

  def create_recipe_file( recipe_name, file_path=nil )
    file_path ||= default_recipe_file_path
    ensure_test_environment
    FileUtils.touch file_path
    File.open( file_path, 'w' ) do |f|
      f.puts send( "#{recipe_name}_recipe_file_contents" )
    end
  end

  def remove_test_environment
    FileUtils.rm_rf temp_path
  end

  def test_dir_path
    File.join temp_path, 'test_dir'
  end

  def default_test_file_path
    File.join temp_path, default_test_file_name
  end

  def default_recipe_file_path
    File.join temp_path, default_recipe_file_name
  end

  def default_test_file_name
    'test_file.txt'
  end

  def default_recipe_file_name
    'test_recipe.rb'
  end

  def temp_path
    File.join File.dirname(__FILE__), '..', 'temp'
  end

  def ensure_test_environment
    ensure_temp_directory
    ensure_test_directory
  end

  def ensure_temp_directory
    FileUtils.mkdir_p temp_path
  end

  def ensure_test_directory
    FileUtils.mkdir_p test_dir_path
  end

  def move_files_recipe_file_contents
    <<-END
set_base_path '#{temp_path}'

move_files do
  like /^\\d+_\\d+_\\d{4}.txt$/
  to "originals"
end
    END
  end
end

RSpec.configure do |config|

  config.include FileArtifactSpecHelper
  # , :example_group => {
  #   :file_path => config.escaped_path(%w[spec phil_columns])
  # }

end
