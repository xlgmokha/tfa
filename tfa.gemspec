# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tfa/version'

Gem::Specification.new do |spec|
  spec.name          = "tfa"
  spec.version       = TFA::VERSION
  spec.authors       = ["mo khan"]
  spec.email         = ["mo@mokhan.ca"]
  spec.summary       = %q{A CLI to manage your time based one time passwords.}
  spec.description   = %q{A CLI to manage your time based one time passwords.}
  spec.homepage      = "https://github.com/mokhan/tfa/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = "~> 2.0"

  spec.add_dependency "rotp", "~> 3.3"
  spec.add_dependency "rqrcode", "~> 0.10"
  spec.add_dependency "thor", "~> 1.0"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rspec", "~> 3.7"
end
