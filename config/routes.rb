Rails.application.routes.draw do
  mount RailsSso::Engine => '/sso', as: 'sso'

  root 'home#index'
 
end
