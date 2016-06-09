Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users do
      resources :accounts
  end

  resources :projects do
    resources :members
    resources :statuses
    resources :api_keys
    resources :boards
    # tracker is just a view on a board ?
    resources :tickets do
      resources :comments do
        resources :attachments do
          get :download, on: :member
        end
      end
      resources :attachments do
        get :download, on: :member
      end
    end
  end

  post 'api_integrations/git_hub' => 'api_integrations#git_hub'


  # NOTE: considder having a top level asset path for downloads of assets
  # resources :assets


  root to: "home#index"
  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end
