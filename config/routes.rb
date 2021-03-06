require "heartbeat/application"

Rails.application.routes.draw do
  mount Heartbeat::Application, at: "/heartbeat"
  namespace :admin do
    get 'users/index'
  end

  namespace :admin do
    root 'application#index'
    resources :projects, only: [:new, :create, :destroy]
    resources :users do
      member do
        patch :archive
      end
    end
    resources :states, only: [:index, :new, :create] do
      member do
        get :make_default
      end
    end
  end

  namespace :api do
    resources :projects, only: [] do
      resources :tickets
    end
  end

  namespace :api do
    namespace :v2 do
      mount API::V2::Tickets, at: "/projects/:project_id/tickets"
    end
  end

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'projects#index'
  resources :projects, only: [:index, :show, :edit, :update] do
    resources :tickets do
      member do
        post :watch
      end
    end
  end
  resources :tickets, only: [] do
    resources :comments, only: [:create]
    resources :tags, only: [] do
      member do
        delete :remove
      end
    end
  end
  resources :attachments, only: [:show, :new]
end
