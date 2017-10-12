Rails.application.routes.draw do
  get '/robots.:format' => 'sitemap#robots'
  get '/sitemap.xml.gz' => 'sitemap#sitemap', format: :xml

  devise_for :users
  resources :items
  resources :saved_items
  resources :boost_lists
  resources :lists do
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
