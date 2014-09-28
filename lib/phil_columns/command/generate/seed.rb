require 'fileutils'
require 'ostruct'
require 'pathname'

module PhilColumns
  module Command
    module Generate
      class Seed < Generator

        def execute
          write "Generating seed #{seed_filepath} ... "
          erb_template_to_file( template_filepath, seed_filepath, class_name: seed_class_name )
          say_ok
        end

      protected

        def template_filepath
          File.expand_path(  '../../../../../templates/seed_class.erb', __FILE__ )
        end

      end
    end
  end
end
