require 'fileutils'
require 'ostruct'
require 'pathname'

module PhilColumns
  module Command
    module List
      class Tags < Base

        include SeedUtils

        def execute
          load_seeds

          each_seed_meta_for_current_env do |seed_meta|
            tags << seed_meta.tags
          end

          say "#{config.env.titlecase} environment seeds use tags:", :cyan

          tags.flatten.uniq.sort.each do |tag|
            say tag
          end
        end

      protected

        def tags
          @tags ||= []
        end

      end
    end
  end
end
