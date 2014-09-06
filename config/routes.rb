Rails.application.routes.draw do
  root :to => 'dynamic_settings#index'
  resources :dynamic_settings, only: [:index, :edit, :update]
end
