Rails.application.routes.draw do
  mount RailsSso::Engine => '/sso', as: 'sso'

  namespace :api do
    get 'users', to: 'users#index'
    get 'users/me', to: 'users#me'
    put 'users/me', to: 'users#update'
  end

  root 'home#index'

end
