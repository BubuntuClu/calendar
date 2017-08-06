require 'sidekiq/web'

Rails.application.routes.draw do

  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users
  resources :notes do
    member do
      post :share_note
    end

    collection do
      get :shared_notes
    end
  end

  root to: "notes#index"
end
