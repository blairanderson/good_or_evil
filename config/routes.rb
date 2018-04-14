require 'constraints/subdomain_white_list'

Rails.application.routes.draw do
  get '/robots.:format' => 'sitemap#robots'
  get '/sitemap.xml.gz' => 'sitemap#sitemap', format: :xml

  constraints(SubdomainWhiteList) do
    get '/' => 'sites#index', as: :site_root
    get '/:id' => 'sites#show', as: :site_list
  end

  constraints subdomain: 'www' do
    devise_for :users, controllers: {registrations: "registrations"}

    resources :accounts do
      resources :lists do
        scope module: :lists do
          resources :items
        end
        member do
          get :preview
        end
      end
      resources :items
      resources :saved_items
      resources :cart_items
      resources :categories, path: 'leaderboard', only: [:show]
      resources :brands
    end

    root to: 'accounts#index'
  end

  # if there is no subdomain, just redirect to WWW
  constraints(subdomain: '') do
    get '/*path' => redirect { |params, request|  URI.parse(request.url).tap { |uri| uri.host = "www.#{uri.host}" }.to_s }
    get '/' => redirect { |params, request|  URI.parse(request.url).tap { |uri| uri.host = "www.#{uri.host}" }.to_s }
  end
end
