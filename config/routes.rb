require 'sidekiq/web'

Iso::Application.routes.draw do
  devise_for :admin_users

  authenticate :admin_user do
    mount Sidekiq::Web => '/sidekiq'
  end

  scope path: "(:locale)", shallow_path: "(:locale)" do
    resources :photographs, only: [:index, :show] do
      collection do
        get :explore
        get :recommended
        get :search, to: redirect("/%{locale}/photographs")
        get :random
        get :favourites
        get :following
        get :seeking_feedback
      end

      member do
        post :recommend
        get :share
      end

      resources :favourites, only: [:create, :destroy]
      resources :reports, only: [:new, :create]
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

      resources :reports, only: [:new, :create]
    end

    resources :categories, only: [:show] do
      resources :photographs, only: [:index]
      resources :collections, only: [:index]
    end

    resources :licenses, only: [:show] do
      resources :photographs, only: [:index]
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

    resources :reports, only: [:new, :create]

    get "/p/:id" => "photographs#share", as: :short_photo
    get "/u/:id" => "users#show", as: :short_user
    get "/c/:id" => "collections#show", as: :short_collection
    get "/status" => "pages#up", as: :status
    get "/stats" => "pages#stats", as: :stats
    get "/sitemap" => "pages#sitemap", as: :sitemap
    get "/about" => "pages#about", as: :about
    get "/terms" => "pages#terms", as: :terms
  end

  get "/auth/:provider/callback" => "account/authorisations#create"

  # Handle root locale path
  get "/:locale" => "pages#home", as: :home
  root to: "pages#home"
end
