Rails.application.routes.draw do
  resources :weather_conditions,  only: [:create]
  root to: 'home#index'
end
