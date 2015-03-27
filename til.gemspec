# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'til/version'

Gem::Specification.new do |spec|
  spec.name          = "til_cli"
  spec.version       = Til::VERSION
  spec.authors       = ["Kevin Litchfield"]
  spec.email         = ["litchfield.kevin+github@gmail.com"]
  spec.summary       = %q{Command-line notetaking application: a CRUD interface to a repo of "Today I Learned" notes. Inspired by the format of https://github.com/thoughtbot/til. Uses $EDITOR to create and edit notes, wraps Git for convenience, more features to come.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "thor", "~> 0.19.1"
  spec.add_dependency "colorize", "~> 0.7.5"
  spec.add_dependency "json", "1.8.1"
end
