require 'aruba/cucumber'
# require 'capybara/cucumber'
# require 'test/unit/assertions'
# World(Test::Unit::Assertions)

Before do
  @aruba_timeout_seconds = 120
end

ENV['PATH'] = "#{File.expand_path(File.dirname(__FILE__) + '/../../bin')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"
