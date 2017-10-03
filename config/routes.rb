Rails.application.routes.draw do

  devise_for :users
  resources :items
  resources :lists do
    collection do
      match :bootstrap, via: [:get, :post]
    end
    scope module: :lists do
      resources :items do
        member do
          get :fetch
        end
      end
    end
    member do
      get :preview
    end

  end
  resources :cart_items
  resources :categories, path: 'leaderboard', only: [:show]
  resources :brands

  root to: 'lists#index'
end
