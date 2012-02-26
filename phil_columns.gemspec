# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "phil_columns/version"

Gem::Specification.new do |s|
  s.name        = "phil_columns"
  s.version     = PhilColumns::VERSION
  s.authors     = ["C. Jason Harrelson (midas)"]
  s.email       = ["jason@lookforwardenterprises.com"]
  s.homepage    = ""
  s.summary     = %q{Tools to help import data to production databases.}
  s.description = %q{Like genesis, the development seeding gem, phil_columns provides tools for importing data into production database environments.}

  s.rubyforge_project = "phil_columns"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "aruba"
  s.add_development_dependency "cucumber"
  s.add_development_dependency 'rb-fsevent'
  s.add_development_dependency 'growl'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'guard-cucumber'
  s.add_development_dependency 'ruby-debug19'
  s.add_development_dependency 'relish'

  s.add_runtime_dependency "mixlib-cli"
end
