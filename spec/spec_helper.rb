require 'bundler/setup'
require 'phil_columns'

Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|

  config.mock_with :rspec

end
