Rails.application.routes.draw do
  mount RailsSso::Engine => '/sso', as: 'sso'
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  namespace :api do
    resources :users do
      collection do
        get '', to: 'users#index'
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
   patch 'birthdays/:celebrant_id/cover', to: 'birthdays#mark_as_covered'
   patch 'birthdays/:celebrant_id/uncover', to: 'birthdays#mark_as_uncovered'
 end

  root 'home#index'

end
