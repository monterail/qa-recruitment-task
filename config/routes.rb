Rails.application.routes.draw do
  mount RailsSso::Engine => '/sso', as: 'sso'

  namespace :api do
    resources :users do
      collection do
        get '', to: 'users#index'
        get '/users_without_birthday', to: 'users#users_without_birthday'
        get '/me', to: 'users#me'
        put '/me', to: 'users#update_me'
      end
    end
    resources :propositions, only: [:update, :create] do
      member do
        put 'choose', to: 'propositions#choose'
        post 'vote', to: 'votes#vote'
        delete 'vote/:vote_id', to: 'votes#unvote'
      end
      resources :comments, only: [:update, :create]
    end
  end

  root 'home#index'

end
