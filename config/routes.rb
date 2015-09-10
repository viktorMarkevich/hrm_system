Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout' }, controllers: { invitations: 'devise/invitations' }

  root 'organisers#index'

  resources :organisers, only: :index
  resources :stickers, except: [:show, :index]
  resources :users, only: [:update, :edit, :show, :index]
  resources :vacancies, except: [:destroy]
  resources :companies
  resources :candidates, except: [:destroy]
  resources :events, except: [:show]
  resources :staff_relations, only: [:new, :create]

  get 'archives/:object_name', to: 'archives#index', as: :archives
  delete 'archives/:object_name/:id', to: 'archives#destroy', as: :restore_object
  
end
