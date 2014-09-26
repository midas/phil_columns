module PhilColumns
  class Seeder

    include PhilColumns::Output

    def initialize( config )
      @config = config
    end

    def execute
      seeds.each do |seed_meta|
        confirm "Executing seed: #{clean_filepath seed_meta.filepath} ... ", :cyan do
          instance = seed_meta.klass.new( config )
          instance.send( method_name )
          record_seed( seed_meta )
        end
      end
    end

  protected

    attr_reader :config

    def record_seed( seed_meta )
      if method_name == :up
        archivist.record_seed( seed_meta.timestamp )
      else
        archivist.remove_seed( seed_meta.timestamp )
      end
    end

    def clean_filepath( filepath )
      File.basename( filepath, '.rb' )
    end

    def archivist
      @archivist ||= PhilColumns::Archivist.new
    end

    def seeds
      @seeds ||= filter.seeds
    end

    def filter
      @filter ||= Filter.new( config )
    end

    def method_name
      return :down if down?
      :up
    end

    def down?
      config.down
    end

  end
end
