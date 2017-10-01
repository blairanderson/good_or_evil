Rails.application.routes.draw do

  devise_for :users
  resources :items
  resources :lists do
    scope module: :lists do
      resources :items do
        member do
          get :fetch
        end
      end
    end
    member do
      get 'preview'
      post 'status'
    end

  end
  resources :categories, path: 'leaderboard', only: [:show]
  resources :brands

  root to: 'lists#index'
end
