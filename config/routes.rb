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

  post 'github/commit/:token' => 'github#commit'

  get 'landing/home'
  get 'landing/tour'
  get 'landing/pricing'
  get 'landing/signup'

  get 'landing/support'
  get 'landing/privacy'
  get 'landing/terms'

  root :to => 'landing#home'
end
