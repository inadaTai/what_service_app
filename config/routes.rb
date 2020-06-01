Rails.application.routes.draw do
  get 'searches/index'
  get 'likes/create'
  get 'likes/destroy'
  root 'home_pages#home'
  get '/home',     to:'home_pages#home'
  get '/timeline', to:'home_pages#timeline'
  get '/about',    to:'home_pages#about'
  get '/help',     to:'home_pages#help'
  get '/contact',  to:'home_pages#contact'
  get '/policy',   to:'home_pages#policy'
  get '/post_pages', to:'home_pages#post_pages'
  get '/likes_pages', to:'home_pages#likes_pages'
  get '/signup',   to:'users#new'
  post '/signup',  to:'users#create'
  get '/login',    to:'sessions#new'
  post '/login',   to:'sessions#create'
  delete '/logout', to:'sessions#destroy'
  get 'password_edits/edit',to:'password_edits#edit'
  get 'auth/:provider/callback', to: 'sessions#create'
  resources :users do
    member do
      get :following, :followers, :likes
    end
  end
  resources :microposts,      only: [:create, :destroy, :show, :update, :edit] do
    resources :comments
  end
  resources :relationships,   only: [:create, :destroy]
  resources :password_edits, only: [:show, :edit, :update]
  resources :favorite_relationships, only: [:create, :destroy]
  resources :notifications, only: :index
  resources :searches, only: [:index, :new, :show, :user]
end
