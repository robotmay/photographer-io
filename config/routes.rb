Iso::Application.routes.draw do
  resources :photographs, only: [:index, :show] do
    collection do
      get :explore
      get :favourite
      get :search
    end
  end

  resources :users, shallow: true, only: [:show] do
    resources :collections, only: [:index, :show] do
      resources :photographs, only: [:index, :show]
    end
  end

  devise_for :users, path: :account
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

    root to: "photographs#index"
  end

  root to: "pages#home"
end
