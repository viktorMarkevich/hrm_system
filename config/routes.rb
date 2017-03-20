Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout' }, controllers: { invitations: 'devise/invitations' }

  root 'organisers#index'

  resources :organisers, only: :index
  resources :stickers, except: [:show, :index]
  resources :users, only: [:update, :edit, :show, :index]
  resources :vacancies
  resources :companies
  resources :candidates, except: [:destroy] do
    member do
      get :set_vacancies
    end
    collection do
      post :upload_resume
    end
  end

  resources :events, except: [:show]
  get '/selected_day_events', to: 'events#selected_day_events'

  resources :staff_relations, only: [:new, :create, :destroy]

  resources :geo_names, only: [:index]

  get 'archives/:object_name', to: 'archives#index', as: :archives
  delete 'archives/:object_name/:id', to: 'archives#destroy', as: :restore_object

  resources :cv_sources, only: :index
  
end
