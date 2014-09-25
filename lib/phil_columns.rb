require 'active_support/core_ext/string'
require 'phil_columns/version'
require 'phil_columns/railtie' if defined? Rails
require 'rainbow'
require 'pry-debugger'

module PhilColumns

  autoload :Archivist,     'phil_columns/archivist'
  autoload :Cli,           'phil_columns/cli'
  autoload :Command,       'phil_columns/command'
  autoload :Configuration, 'phil_columns/configuration'
  autoload :Error,         'phil_columns/error'
  autoload :Filter,        'phil_columns/filter'
  autoload :Migrator,      'phil_columns/migrator'
  autoload :Seed,          'phil_columns/seed'

  class << self
    attr_accessor :archivist_klass
  end

end
