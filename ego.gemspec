# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ego/version'

Gem::Specification.new do |spec|
  spec.name          = "ego"
  spec.version       = Ego::VERSION
  spec.authors       = ["Noah Frederick"]
  spec.email         = ["hi@noahfrederick.com"]
  spec.summary       = %q{An extensible personal command-line assistant}
  spec.description   = %q{Ego is a personal command-line assistant that provides a flexible, natural language interface (sort of) for interacting with other programs.}
  spec.homepage      = "https://github.com/noahfrederick/ego"
  spec.license       = "GPL-3.0+"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end