Xmppify::Engine.routes.draw do
  devise_for :users
  root to: 'high_voltage/pages#show', id: 'index' 
end