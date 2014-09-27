module PhilColumns
  module Command
    module List
      class TaggedWith < Base

        include SeedUtils

        def execute
          load_seeds

          say "#{config.env.titlecase} seeds tagged with #{config.operation} #{config.tags.inspect}:", :cyan

          filter.send( "calculate_seed_set_#{config.operation}" ).each do |seed_meta|
            say seed_meta.filepath
          end
        end

      protected

        def filter
          @filter ||= Filter.new( config )
        end

      end
    end
  end
end
