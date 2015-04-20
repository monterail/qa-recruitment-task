Rails.application.routes.draw do
  mount RailsSso::Engine => '/sso', as: 'sso'

  namespace :api do
    resources :users do
      collection do
        get '', to: 'users#index'
        get '/me', to: 'users#edit'
        put '/me', to: 'users#update'
      end
      resources :propositions, only: [:index, :update, :create] do
        resources :comments, only: [:index, :update, :create]
      end
    end
  end

  root 'home#index'

end
