Iso::Application.routes.draw do
  devise_for :users, path: :account

  namespace :account do
    resources :photographs
  end

  root to: "pages#home"
end
