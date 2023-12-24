# frozen_string_literal: true

Rails.application.routes.draw do
  resources :recipient_lists
  resources :message_recipients
  resources :recipients

  resources :messages
  post 'messages/:id/send', to: 'messages#send_message', as: 'send_message'
  devise_for :users
  devise_for :admins
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root 'messages#index'
end
