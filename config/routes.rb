Xmppify::Engine.routes.draw do
  devise_for :users, path_names: {sign_in: "login", signout: "logout"}, controllers: {omniauth_callbacks: "omniauth_callbacks", :invitations => 'invitations', :registrations => "registrations", confirmations: "confirmations"}
  root to: 'high_voltage/pages#show', id: 'index' 
  path_prefix = Devise.omniauth_path_prefix || "/#{mapping.path}/auth".squeeze("/")
  set_omniauth_path_prefix!(path_prefix)
end