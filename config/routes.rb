Rails.application.routes.draw do
  require 'sidekiq/web'

  root to: 'urls#index'
  get '/:short_url', to: 'urls#redirect', as: :redirect

  resources :urls, only: :create

  mount Sidekiq::Web => 'admin/sidekiq'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
