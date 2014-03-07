require 'sidekiq/web'

Eightfoot::Application.routes.draw do
  root :to => 'projects#index'

  resources :repositories

  resources :issues

  resources :projects do
    member do
      get  'show_repos'
      post 'add_repos'
      get  'add_labels'
      get  'search_repos'
    end
    post :change_heading
    post :update_position
    resources :issues do
    end
  end

  get 'updates' => 'updates#index'

  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}

  resources :users
  authenticate :user do
    mount Sidekiq::Web, at: "/sidekiq"
  end
end
