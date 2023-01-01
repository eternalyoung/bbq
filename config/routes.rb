Rails.application.routes.draw do
  devise_for :users
  root 'events#index'

  resources :events do
    resources :comments, only: [:create, :destroy]
    resources :subscriptions, only: [:create, :destroy]
  end
  resources :users, only: [:show, :edit, :update]
end
