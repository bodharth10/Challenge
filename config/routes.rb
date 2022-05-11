Rails.application.routes.draw do
  get 'upload/create'
  root 'dashboard#index'
  devise_for :users
  get '/dashboard', to: 'dashboard#index'
  get '/upload', to: 'upload#create', as: 'upload_file'
  namespace :api do
    namespace :v1 do
      resources :upload, only: [:index, :create, :destroy, :update] do
      end
    end
  end
end
