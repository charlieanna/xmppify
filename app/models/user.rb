require 'yaml'
require 'ruby_bosh'
class User < ActiveRecord::Base
  # include PublicActivity::Model
  # tracked
  has_many :identities
  # has_merit
  # acts_as_followable
  # acts_as_follower
  devise  :database_authenticatable, :omniauthable, :omniauth_providers => [:doorkeeper]

  after_create :register_user
  def self.find_or_create_for_doorkeeper_oauth(oauth_data)
    ap oauth_data
    User.find_or_initialize_by_doorkeeper_uid(oauth_data.uid).tap do |user|
      user.email = oauth_data.info.email
      user.name = oauth_data.info.name
    end
  end

  def update_doorkeeper_credentials(oauth_data)
    self.doorkeeper_access_token = oauth_data.credentials.token
  end
  has_many :projects

  def github_auth_token
    identities.find_by(provider:"github").auth_token
  end

  def register_user
    self.encrypted_data = RubyBOSH.register(self)
    self.save
  end



  def connect
    @jid, @sid, @rid = RubyBOSH.initialize_session("#{self.encrypted_data}@idlecampus.com", "#{ENV['DOORKEEPER_APP_SECRET']}", "http://idlecampus.com:5280/http-bind")
   return {jid: @jid, id: @sid, rid: @rid }
  end
end
