# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'phil_columns/version'

Gem::Specification.new do |spec|
  spec.name          = "phil_columns"
  spec.version       = PhilColumns::VERSION
  spec.authors       = ["JC. ason Harrelson (midas)"]
  spec.email         = ["jason@lookforwardenterprises.com"]
  spec.summary       = %q{A utility for seeding databases for development and production.}
  spec.description   = %q{A utility for seeding databases for development and production.  See README for more details.}
  spec.homepage      = "https://github.com/midas/phil_columns"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "pry-debugger"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_dependency "activesupport"
  spec.add_dependency "hashie"
  spec.add_dependency "rainbow"
  spec.add_dependency "thor"
end
