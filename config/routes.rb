# frozen_string_literal: true
require 'constraints/subdomain_white_list'

Rails.application.routes.draw do
  # get '/robots.:format' => 'sitemap#robots'
  # get '/sitemap.xml.gz' => 'sitemap#sitemap', format: :xml

  # FIRST CHECK FOR CLIENT SITES. SHOULD BE FASTEST
  constraints(SubdomainWhiteList) do
    get '/robots.:format' => 'sitemap#robots'
    get '/sitemap.xml.gz' => 'sitemap#sitemap', format: :xml

    get '/' => 'sites#index', as: :site_root
    get '/:id' => 'sites#show', as: :site_list
  end

  # NEXT MAKE SURE USER IS VISITING OUR WWW AND NOT ANYTHING ELSE
  constraints subdomain: 'www' do
    devise_for :users, controllers: {registrations: 'registrations', confirmations: 'confirmations'}
    devise_scope :user do
      patch '/user_update' => 'registrations#user_update'
      patch '/confirm' => 'confirmations#confirm'
    end

    resources :account_invitations, only: [:index, :create, :destroy]
    resources :list_item_ingredients, only: [:create, :update]
    resources :accounts do
      resources :lists do
        scope module: :lists do
          resources :items do
            member do
              post :sort
            end
          end
        end
        member do
          get :preview
          get :checklist
        end
      end
      resources :items
      resources :saved_items
      resources :categories, path: 'leaderboard', only: [:show]
      resources :brands
    end
    get :inspiration, to: 'landing#inspiration', as: :inspiration
    get :started, to: 'landing#started', as: :get_started
    root to: 'landing#index'
  end

  # if there is no subdomain, redirect to WWW
  constraints(subdomain: '') do
    get '/*path' => redirect { |params, request| URI.parse(request.url).tap { |uri| uri.host = "www.#{uri.host}" }.to_s }
    get '/' => redirect { |params, request| URI.parse(request.url).tap { |uri| uri.host = "www.#{uri.host}" }.to_s }
  end
end
