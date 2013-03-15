Conductor::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' , :invitations => 'users/invitations' }

  resources :users

  resources :projects do
    resources :tickets do
      resources :comments
    end
    resource  :access
    resources :features
    resources :sprints
  end

  post 'comments/preview'

  # Ridiculous as it seems, without this route, previewing an existing comment
  # that you're editing posts text/html, not application/json to the server,
  # resulting in a 500 error
  put 'comments/preview' 

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
