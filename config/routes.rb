Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'admin/dashboard#index'

  get 'view_participant_payments', to: 'admin/planned_tours#view_participant_payments'
  resources :health_checks, only: [:index]
  resources :locations, only: [:index] do
    get :get_nearest_poi, on: :collection
    get :puri_stops, on: :collection
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :locations, only: [:create] do
        post :record_location, on: :collection
      end

      resources :user_sessions, only: [:create, :destroy] do
        collection do
          get :get_user
          put :reset_password
        end
      end

      resources :fuel_entries
    end
  end
end
