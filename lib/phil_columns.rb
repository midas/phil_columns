require 'fileutils'

module PhilColumns

  autoload :Cli,     "#{File.dirname __FILE__}/phil_columns/cli"
  autoload :Command, "#{File.dirname __FILE__}/phil_columns/command"
  autoload :Railtie, "#{File.dirname __FILE__}/phil_columns/railtie"
  autoload :Recipe,  "#{File.dirname __FILE__}/phil_columns/recipe"
  autoload :Version, "#{File.dirname __FILE__}/phil_columns/version"

end
