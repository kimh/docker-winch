# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'docker-winch/version'

Gem::Specification.new do |spec|
  spec.name          = "docker-winch"
  spec.version       = Docker::Winch::VERSION
  spec.authors       = ["Kim, Hirokuni"]
  spec.email         = ["hirokuni.kim@kvh.co.jp"]
  spec.description   = %q{Brings true portability to Docker}
  spec.summary       = %q{Makes Docker workflow easier with true portability of containers.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency 'docker-api'
  spec.add_runtime_dependency 'colorize'
  spec.add_runtime_dependency 'thor'
end
