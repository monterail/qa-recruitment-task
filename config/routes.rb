Rails.application.routes.draw do
  mount RailsSso::Engine => '/sso', as: 'sso'

  namespace :api do
    resources :users, only: [:index, :update, :show]
  end

  root 'home#index'

end
