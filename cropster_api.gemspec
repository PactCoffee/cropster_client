# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cropster_api/version'

Gem::Specification.new do |spec|
  spec.name          = "cropster_api"
  spec.version       = CropsterApi::VERSION
  spec.authors       = ["Srikanth Kunkulagunta"]
  spec.email         = ["srikanth.kunkulagunta@gmail.com"]
  spec.summary       = %q{wrapper for cropster API}
  spec.description   = %q{wrapper for cropster API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty"
  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "dotenv-rails"
end
