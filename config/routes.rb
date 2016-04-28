Rails.application.routes.draw do
  require "sidekiq/web"
  require "signed_in_constraint"

  mount RailsSso::Engine => "/sso", as: "sso"
  mount Sidekiq::Web, at: "/sidekiq", constraints: SignedInConstraint.new
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  namespace :api do
    resources :users do
      collection do
        get "", to: "users#index"
        get "/unset", to: "users#users_without_birthday"
        get "/me", to: "users#me"
        put "/me", to: "users#update_me"
      end
      post "/emails", to: "users#send_emails"
    end
    resources :propositions, only: [:update, :create, :destroy] do
      member do
        put "choose", to: "propositions#choose"
        put "unchoose", to: "propositions#unchoose"
        post "vote", to: "votes#vote"
        delete "vote/:vote_id", to: "votes#unvote"
      end
      resources :comments, only: [:update, :create, :destroy]
    end
    patch "birthdays/:celebrant_id/cover", to: "birthdays#mark_as_covered"
    patch "birthdays/:celebrant_id/uncover", to: "birthdays#mark_as_uncovered"
  end

  root "home#index"
end
