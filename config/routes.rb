# frozen_string_literal: true
Rails.application.routes.draw do
  # get '/robots.:format' => 'sitemap#robots'
  # get '/sitemap.xml.gz' => 'sitemap#sitemap', format: :xml

  resources :articles

  # NEXT MAKE SURE USER IS VISITING OUR WWW AND NOT ANYTHING ELSE
  devise_for :users, controllers: {registrations: 'registrations', confirmations: 'confirmations'}
  devise_scope :user do
    patch '/user_update' => 'registrations#user_update'
    patch '/confirm' => 'confirmations#confirm'
  end

  get :inspiration, to: 'landing#inspiration', as: :inspiration
  get :started, to: 'landing#started', as: :get_started
  root to: 'landing#index'

end
