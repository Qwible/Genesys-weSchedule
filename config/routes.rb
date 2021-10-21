# frozen_string_literal: true

Rails.application.routes.draw do
  resources :tasks do
    collection do
      post 'generate_time_table'
    end
    resources :calendar_events, only: [:update, :create, :destroy]
  end
  resources :feedbacks
  devise_for :users, controllers: { registrations: 'devise_registration' }

  resources :questions, only: %i[index update create] do
    member do
      post 'hide_and_unhide'
      post 'increase_score'
      post 'decrease_score'
      post 'express_interest'
    end
  end
  resources :registrations, only: %i[new create]
  resources :link_clicks, only: :create
  resources :metrics, only: :index do
    collection do
      get 'maps'
      get 'users'
      get 'user_logins_chart'
      get 'feedback'
    end
  end
  resources :share_metrics, only: :index
  resources :visits, only: :index
  resources :reviews, only: %i[index create] do
    member do
      post 'hide_and_unhide'
      post 'increase_score'
      post 'decrease_score'
      post 'pin_review'
    end
  end
  resources :user_preferences, only: :index do
    collection do
      post 'update'
    end
  end

  # error routing
  match '/403', to: 'errors#error_403', via: :all
  match '/404', to: 'errors#error_404', via: :all
  match '/422', to: 'errors#error_422', via: :all
  match '/500', to: 'errors#error_500', via: :all

  get :ie_warning, to: 'errors#ie_warning'
  get :javascript_warning, to: 'errors#javascript_warning'

  # navbar links, public user viewable pages
  get 'questions', to: 'pages#questions'
  get 'gallery', to: 'pages#gallery'
  get 'reviews', to: 'pages#reviews'
  get 'contact', to: 'pages#contact'
  get 'pricing', to: 'pages#product_pro'
  get 'calendar', to: 'tasks#index'
  get 'help', to:'pages#help'
  get 'user_feedback', to: 'pages#metrics_feedback'
  # metrics and metrics subpage routes
  get 'metrics', to: 'pages#metrics'

  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
