Rails.application.routes.draw do
  mount RailsSso::Engine => '/sso', as: 'sso'

  root 'application#index'
end
