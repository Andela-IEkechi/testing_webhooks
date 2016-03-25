Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :projects do
    resources :boards
    resources :tickets do
      resources :comments
    end
    resources :documents
  end


  resources :overviews

  namespace :admin do
    resources :users
  end

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'

  # Server validation requests in-process
  mount Judge::Engine => '/judge'


  # deal with actions for logged out users
  get 'welcome/home'
  get 'welcome/tour'
  get 'welcome/pricing'

  get 'welcome/support'
  get 'welcome/privacy'
  get 'welcome/terms_and_conditions'

  root :to => 'welcome#home'
end
