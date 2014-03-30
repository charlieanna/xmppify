# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xmppify/version'

Gem::Specification.new do |spec|
  spec.name          = "xmppify"
  spec.version       = Xmppify::VERSION
  spec.authors       = ["Charlie"]
  spec.email         = ["ankothari@gmail.com"]
  spec.summary       = "A gem for all your real time communication needs like group chatting, one-on-one chatting for Android and iOS devices. It also includes strophe.js for sending data to and from the browser. "
  spec.description   = "We have extracted out the logic from IdleCampus and built xmppify because I want to help anyone built a real time communication platform or a product as soon as possible. I am also working on creating a service so that mobile developers could easily implement all the required libraries and functionalities without much work which I had to do in the last 3 years. "
  spec.homepage      = "https://github.com/charlieanna/xmppify"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'angularjs-rails'
  spec.add_dependency 'devise'
  spec.add_development_dependency 'gon'
  spec.add_development_dependency 'rest-client'
  spec.add_development_dependency 'hpricot'
  spec.add_development_dependency 'omniauth-oauth2'  
  spec.add_development_dependency 'doorkeeper'  
end
