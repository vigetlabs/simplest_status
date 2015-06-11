# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'simplest_status/version'

Gem::Specification.new do |spec|
  spec.name          = "simplest_status"
  spec.version       = SimplestStatus::VERSION
  spec.authors       = ["Ryan Stenberg"]
  spec.email         = ["ryan.stenberg@viget.com"]

  spec.summary       = "Simple status functionality for Rails models."
  spec.description   = "SimplestStatus provides a dead-simple DSL for defining statuses on Rails models, which generates scopes, constants, and a number of instance-level convenience methods."
  spec.homepage      = "https://github.com/vigetlabs/simplest_status"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w(lib)

  spec.add_dependency "rails"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "appraisal"
end
