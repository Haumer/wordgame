Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :users, only: [:show, :update]
  namespace :auths do
    get 'google/auth', to: 'google#auth', as: :google_auth
    get 'google/sign_in', to: 'google#sign_in', as: :google_sign_in
  end
end
