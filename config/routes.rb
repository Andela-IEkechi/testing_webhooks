Conductor::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' , :invitations => 'users/invitations' }

  resources :users do
    resource :account do
      post 'payment/failure' => 'accounts#payment_failure'
      post 'payment/success' => 'accounts#payment_success'
    end
  end

  resources :projects do
    resources :tickets do
      resources :comments
    end
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
