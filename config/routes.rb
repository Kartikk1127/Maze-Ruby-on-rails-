Rails.application.routes.draw do
  devise_for :users
  resources :users,only: [:index, :create, :new] do
    get "/new", to: "users#new"
    post '/new', to: "users#create", as: 'users_create'
    # get '/users', to: "users#index"
    get '/downloads', to: "users#downloads"
    get '/post', to: "users#post"
    member do
      patch :ban
    end
  end


  root "articles#index"

  resources :articles do
    resources :comments
    # match '/users',   to: 'users#index',   via: 'get'
  end

  resources :articles do
    resources :likes
  end
end
