Xmppify::Engine.routes.draw do
  devise_for :users, path_names: {sign_in: "login", signout: "logout"}, controllers: {omniauth_callbacks: "omniauth_callbacks", :invitations => 'invitations', :registrations => "registrations", confirmations: "confirmations"}, class_name:  'Xmppify::User',
    module: :devise,
  root to: 'high_voltage/pages#show', id: 'index' 
end