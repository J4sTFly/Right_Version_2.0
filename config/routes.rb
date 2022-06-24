# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: %i[registrations confirmations], skip_helpers: false
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace 'v1' do
    resources :users, only: %i[index create destroy]
    scope 'users' do
      # get '/:slug', to: 'users#show'
      # post '/:slug', to: 'users#update'
    end

    scope 'emails' do
      get '/confirm/:token', to: 'confirmations#confirm_email'
    end

    scope 'passwords' do
      post '/restore', to: 'passwords#restore_password'
      post '/reset/:reset_password_token', to: 'passwords#update_password'
    end

    scope 'account' do
      post '/login', to: 'accounts#login'
      delete '/logout', to: 'accounts#logout'
    end
  end
  # Defines the root path route ("/")
  # root "articles#index"
  #
  # devise_for :users, skip: [:registrations, :confirmations], skip_helpers: false
end
