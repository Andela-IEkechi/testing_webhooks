Conductor::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' }

  resources :users

  resources :projects do
    resources :tickets do
      resources :comments
    end
    resource  :key
    resource  :access
    resources :features
    resources :sprints
  end

  get 'landing/home'
  get 'landing/tour'
  get 'landing/pricing'
  get 'landing/signup'
  get 'landing/support'

  post 'github/commit/:token' => 'github#commit'

  root :to => 'projects#index'
end
