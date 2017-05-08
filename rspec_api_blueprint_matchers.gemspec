# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec_apib/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec_api_blueprint_matchers"
  spec.version       = RSpecApib::VERSION
  spec.authors       = ["Shift Commerce Ltd"]
  spec.email         = ["team@shiftcommerce.com"]

  spec.summary       = %q{API Blueprint Tools For RSpec}
  spec.description   = %q{API Blueprint Tools For RSpec - Matching http transactions against an API Blueprint document to ensure the API that you are implementing matches the API that is documented which your clients will expect to be the case.}
  spec.homepage      = "https://github.com/shiftcommerce/rspec_api_blueprint_matchers"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency "addressable", ">= 2.5.0"
  spec.add_dependency "json-schema", ">= 2.8.0"
  spec.add_dependency "rspec", ">= 3.0"
  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "rake", "~> 10.0"
end
