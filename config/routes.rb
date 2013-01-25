Conductor::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :users

  resources :projects do
    resources :tickets do
      resources :comments
      resources :api_keys
    end
    resource  :access
    resources :features
    resources :sprints
  end

  post 'github/commit/:project_id' => 'github#commit'

  root :to => 'projects#index'
end
