Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'pages#home'
  get '/dashboard', to: 'pages#dashboard'
  get '/dashboard/album/:id', to: 'pages#tick', as: "tick"
  get '/create_artist', to: 'pages#create_artist'
  post '/create_artist', to: 'pages#scraping_artist'
  get '/result/:name', to: 'pages#result_artist'

  resources :artists, only: %i[index show] do
    get '/add', to: 'artists#add'
    resources :albums, only: %i[show] do
      resources :songs, only: %i[show]
    end
  end

  resources :collaborations, only: %i[create]
end
