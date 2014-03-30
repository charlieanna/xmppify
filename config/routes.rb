Xmppify::Engine.routes.draw do
  devise_for :users, class_name: "Xmppify::User", module: :devise
  
end