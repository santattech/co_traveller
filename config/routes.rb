Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'admin/dashboard#index'

  get 'view_participant_payments', to: 'admin/planned_tours#view_participant_payments'
  resources :health_checks, only: [:index]
  resources :locations, only: [:index]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :locations, only: [:create]
    end
  end
end
