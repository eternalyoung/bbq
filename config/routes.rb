Rails.application.routes.draw do
  resources :photos
  devise_for :users
  root 'events#index'

  resources :events do
    resources :comments, only: %i[create destroy]
    resources :subscriptions, only: %i[create destroy]
    resources :photos, only: %i[create destroy]
    post :show, on: :member
  end
  resources :users, only: %i[show edit update]
end
