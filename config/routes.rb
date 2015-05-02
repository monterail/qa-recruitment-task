Rails.application.routes.draw do
  mount RailsSso::Engine => '/sso', as: 'sso'

  namespace :api do
    resources :users do
      collection do
        get '', to: 'users#index'
        get '/me', to: 'users#me'
        put '/me', to: 'users#update_me'
      end
      resources :propositions, only: [:update, :create] do
        resources :comments, only: [:update, :create]
      end
    end
  end

  root 'home#index'

end
