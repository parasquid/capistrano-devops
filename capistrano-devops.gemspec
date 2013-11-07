# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/devops/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-devops"
  spec.version       = Capistrano::Devops::VERSION
  spec.authors       = ["tristan"]
  spec.email         = ["tristan.gomez@gmail.com"]
  spec.description   = %q{yay}
  spec.summary       = %q{yay}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'capistrano', '~> 3'
  spec.add_dependency 'capistrano-bundler'
end
