require "xmppify/version"
require "xmppify/strategies/doorkeeper"
require 'rails'
require 'devise'
require 'omniauth-oauth2'
require 'xmpp4r'
require 'doorkeeper'
require 'hpricot'
require 'gon'
require 'high_voltage'

module Xmppify
  class Engine < Rails::Engine
  end
end