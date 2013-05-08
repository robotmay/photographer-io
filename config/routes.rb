require 'sidekiq/web'

Iso::Application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resources :photographs, only: [:index, :show] do
    collection do
      get :explore
      get :recommended
      get :search
      get :random
    end

    member do
      post :recommend
    end

    resources :favourites, only: [:create, :destroy]
  end

  resources :categories, shallow: true, only: [:show] do
    resources :photographs, only: [:index]
  end

  resources :users, shallow: true, only: [:show] do
    resources :collections, only: [:index, :show] do
      resources :photographs, only: [:index]
    end

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
      end
    end

    resources :collections, shallow: true do
      resources :photographs
    end

    root to: "account#dashboard"
  end

  root to: "pages#home"
end
