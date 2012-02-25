require 'rubygems'
require 'mixlib/cli'

module PhilColumns

  class Cli

    include Mixlib::CLI

    option :base_path,
      :short => "-p PATH",
      :long => "--path PATH",
      :description => "Override the base path set in the recipe"

    option :help,
      :short => "-h",
      :long => "--help",
      :description => "Show this message",
      :on => :tail,
      :boolean => true,
      :show_options => true,
      :exit => 0

    def recipe_path
      ARGV.first
    end

    def run!
      parse_options
      PhilColumns::Recipe.new( recipe_path,
                               config[:base_path] ).execute!
    end

  end

end

cli = PhilColumns::Cli.new
cli.run!
