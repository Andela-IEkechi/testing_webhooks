Conductor::Application.routes.draw do
  devise_for :users, :token_authentication_key => 'authentication_key', :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' , :invitations => 'users/invitations', :registrations => "users/registrations" }

  resources :users do
    resource :account do
      match 'payment/failure' => 'accounts#payment_failure'
      match 'payment/success' => 'accounts#payment_success'
    end
  end

  get 'projects/public' => 'projects#public'
  get 'projects/:id/invite' => 'projects#invite', :as => :invite

  resources :projects do
    resources :tickets do
      resources :comments
    end
    resource  :access
    resources :features
    resources :sprints
  end

  post 'comments/preview', :as => :comment_preview

  post 'github/commit/:token' => 'github#commit'

  get 'landing/home'
  get 'landing/tour'
  get 'landing/pricing'

  get 'landing/support'
  get 'landing/privacy'
  get 'landing/terms'

  root :to => 'landing#home'
end
