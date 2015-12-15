# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth/whiplash/version'

Gem::Specification.new do |spec|
  spec.name          = "omniauth-whiplash"
  spec.version       = Omniauth::Whiplash::VERSION
  spec.authors       = ["Mark Dickson", "Nikhil Gupta"]
  spec.email         = ["mark@whiplashmerch.com", "me@nikhgupta.com"]

  spec.summary       = %q{Omniauth Strategy for Whiplash Merchandising}
  spec.description   = %q{Omniauth Strategy for Whiplash Merchandising}
  spec.homepage      = "https://github.com/ideaoforder/omniauth-whiplash"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"

  spec.add_dependency 'omniauth', '~> 1.0'
  spec.add_dependency 'omniauth-oauth2', '~> 1.3.1'
end
