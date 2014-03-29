require 'xmppify'
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def doorkeeper
    oauth_data = request.env["omniauth.auth"]
    @user = User.find_or_create_for_doorkeeper_oauth(oauth_data)
    @user.update_doorkeeper_credentials(oauth_data)
    @user.save
    xmpp_credentials = sign_in_as @user
    ap xmpp_credentials
    flash[:attacher] = attacher(xmpp_credentials)
    if @user.identities.find_by(provider:"github").nil?
      @user.identities.create(provider:"github",auth_token:oauth_data.info.github_auth_token,email:oauth_data.info.github_email) 
    end
    sign_in @user
    redirect_to dashboard_path
  end

  private

  def sign_in_as(user)
    return user.connect
  end

  def attacher(xmpp_credentials)
    {
      jid: xmpp_credentials.jid,
      id: xmpp_credentials.sid,
      rid: xmpp_credentials.rid
    }
  end
end
