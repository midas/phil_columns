require 'fileutils'
require 'ostruct'
require 'pathname'

module PhilColumns
  module Command
    class Generator < Base

    protected

      def template_filepath
        raise NotImplementedError
      end

      def erb_template_to_file( template_filepath, dest_filepath, namespace )
        template_filepath = template_filepath.is_a?( Pathname ) ?
                              template_filepath :
                              Pathname.new( template_filepath )
        namespace = OpenStruct.new( namespace )

        File.open( dest_filepath, 'w' ) do |f|
          result = ERB.new( template_filepath.read ).result( namespace.instance_eval { binding } )
          f.write( result )
        end
      end

      def seed_filepath
        @seed_filepath ||= File.join( config.seeds_path, seed_name )
      end

      def seed_class_name
        @seed_class_name ||= config.seed_name.camelize
      end

      def seed_name
        @seed_name ||= "#{timestamp}_#{config.seed_name}.rb"
      end

      def timestamp
        @timestamp ||= Time.now.strftime( '%Y%m%d%H%M%S' )
      end

    end
  end
end
