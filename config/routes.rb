Rails.application.routes.draw do
  root to: 'pages#home'

  devise_for :users

  get '/dashboard', to: 'pages#dashboard'
  get '/dashboard/album/:id', to: 'pages#tick', as: 'tick'
  get '/create_artist', to: 'pages#create_artist'
  post '/create_artist', to: 'pages#scraping_artist'
  get '/result/:name', to: 'pages#result_artist'

  resources :artists, only: %i[index show edit update] do
    get '/add', to: 'artists#add'
    resources :albums, only: %i[show edit update] do
      resources :songs, only: %i[show edit update]
    end
  end

  resources :performers, only: %i[index show edit update]

  resources :collaborations, only: %i[create]
end
