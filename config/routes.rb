Conductor::Application.routes.draw do
  devise_for :users,
    :token_authentication_key => 'authentication_key',
    :controllers => {
      :omniauth_callbacks => 'users/omniauth_callbacks',
      :invitations => 'users/invitations',
      :registrations => "users/registrations"
    }

  resources :users do
    resource :account do
      match 'payment/return' => 'accounts#payment_return'
      match 'payment/update' => 'accounts#payment_update'
    end
    resources :overviews
  end
  match 'startup_fee' => 'accounts#ajax_startup_fee'

  get 'projects/public' => 'projects#public'
  get 'projects/:id/invite' => 'projects#invite', :as => :invite

  resources :projects do
    resources :tickets do
      resources :comments
      get 'download_asset/:asset_id' => 'assets#download', :as => :download_asset
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
