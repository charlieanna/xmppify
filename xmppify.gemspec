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
  spec.test_files = Dir["spec/**/*"]
  spec.add_dependency "bundler", "~> 1.5"
  spec.add_dependency "rake"
  spec.add_dependency 'angularjs-rails'
  spec.add_dependency 'devise'
  spec.add_dependency 'gon'
  spec.add_dependency 'rest-client'
  spec.add_dependency 'hpricot'
  spec.add_dependency 'omniauth-oauth2'  
  spec.add_dependency 'doorkeeper'  
  spec.add_dependency  'xmpp4r','0.5.5'
  spec.add_development_dependency 'dotenv-rails'
  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'guard-rspec', '2.5.0'
  spec.add_development_dependency 'spork-rails', '4.0.0'
  spec.add_development_dependency 'guard-spork', '1.5.0'
  spec.add_development_dependency 'childprocess'
  spec.add_development_dependency 'factory_girl_rails'
  spec.add_development_dependency "database_cleaner", "~> 1.2.0"
  spec.add_dependency 'high_voltage', '~> 2.1.0'
  spec.add_development_dependency  "poltergeist"
  spec.add_development_dependency  'capybara'
  spec.add_development_dependency 'launchy'
end
