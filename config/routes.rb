Conductor::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :users

  resources :tickets do
    resources :comments
  end

  resources :projects do
    resource  :access
    resources :features
    resources :sprints
  end

  get 'github/commit'
  root :to => 'projects#index'
end
