Rails.application.routes.draw do
  resources :foos
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'


  # deal with actions for logged out users
  get 'welcome/home'
  get 'welcome/tour'
  get 'welcome/pricing'

  get 'welcome/support'
  get 'welcome/privacy'
  get 'welcome/terms_and_conditions'

  root :to => 'welcome#home'
end
