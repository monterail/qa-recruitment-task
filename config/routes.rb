Rails.application.routes.draw do
  mount RailsSso::Engine => '/sso', as: 'sso'

  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :update, :show]
    end
  end

  root 'home#index'
 
end
