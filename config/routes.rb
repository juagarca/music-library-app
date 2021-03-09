Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :artists, only: %i[index show] do
    resources :albums, only: %i[show]
  end

  get '/dashboard', to: 'pages#dashboard'
end
