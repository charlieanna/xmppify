require 'xmppify'
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def doorkeeper
    oauth_data = request.env["omniauth.auth"]
    @user = User.find_or_create_for_doorkeeper_oauth(oauth_data)
    @user.update_doorkeeper_credentials(oauth_data)
    @user.save
    sign_in_as @user
    flash[:attacher] = attacher(self.resource)
    if @user.identities.find_by(provider:"github").nil?
      @user.identities.create(provider:"github",auth_token:oauth_data.info.github_auth_token,email:oauth_data.info.github_email) 
    end
    sign_in @user
    redirect_to dashboard_path
  end

  private

  def sign_in_as(user)
    user.connect
  end

  def attacher(user)
    {
      jid: user.jid,
      id: user.sid,
      rid: user.rid
    }
  end
end
