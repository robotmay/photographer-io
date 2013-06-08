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
      get :following
      get :seeking_feedback
    end

    member do
      post :recommend
    end

    resources :favourites, only: [:create, :destroy]
  end

  resources :comment_threads do
    resources :comments, only: [:create, :update, :destroy] do
      member do
        get :toggle
      end
    end
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

  resources :notifications, only: [:index, :show] do
    collection do
      get :mark_all_as_read
    end
  end

  resources :users, shallow: true, only: [:show] do
    resources :collections, only: [:index, :show] do
      resources :photographs, only: [:index]
    end

    resources :followings, only: [:create, :destroy]
    resources :photographs, only: [:index]
  end

  devise_for :users, path: :account, controllers: { 
    registrations: "devise_extensions/registrations",
    invitations: "devise_extensions/invitations"
  }
  namespace :account do
    resources :photographs do
      collection do
        get :public
        get :private
        get :unsorted
        post :mass_update
        get :typeahead
      end
    end

    resources :collections, shallow: true do
      resources :photographs do
        collection do
          post :mass_update
        end
      end
    end

    resources :authorisations, only: [:index]

    root to: "account#dashboard"
  end

  get "/p/:id" => "photographs#show", as: :short_photo
  get "/u/:id" => "users#show", as: :short_user
  get "/c/:id" => "collections#show", as: :short_collection
  get "/stats" => "pages#stats"
  get "/sitemap" => "pages#sitemap"

  get "/auth/:provider/callback" => "account/authorisations#create"

  root to: "pages#home"
end
