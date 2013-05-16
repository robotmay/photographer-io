require 'sidekiq/web'

Iso::Application.routes.draw do
  devise_for :admin_users

  authenticate :admin_user do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :photographs, only: [:index, :show] do
    collection do
      get :explore
      get :recommended
      get :search
      get :random
      get :favourites
    end

    member do
      post :recommend
    end

    resources :favourites, only: [:create, :destroy]
  end

  resources :collections, only: [:index, :show] do
    collection do
      get :explore
    end
  end

  resources :categories, shallow: true, only: [:show] do
    resources :photographs, only: [:index]
    resources :collections, only: [:index]
  end

  resources :users, shallow: true, only: [:show] do
    resources :collections, only: [:index, :show] do
      resources :photographs, only: [:index]
    end

    resources :followings, only: [:create, :destroy]
    resources :photographs, only: [:index]
  end

  devise_for :users, path: :account, controllers: { 
    registrations: "devise_extensions/registrations" 
  }
  namespace :account do
    resources :photographs do
      collection do
        get :public
        get :private
        get :unsorted
        post :mass_update
      end
    end

    resources :collections, shallow: true do
      resources :photographs do
        collection do
          post :mass_update
        end
      end
    end

    root to: "account#dashboard"
  end

  get "/p/:id" => "photographs#show"
  get "/u/:id" => "users#show"
  get "/c/:id" => "collections#show"
  get "/stats" => "pages#stats"

  root to: "pages#home"
end
