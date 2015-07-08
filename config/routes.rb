Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout' }, controllers: { invitations: 'devise/invitations' }

  root 'stickers#index'

  resources :stickers, except: [:show] do
    get 'archives', to: 'archives#index', on: :collection
    delete 'archives', to: 'archives#destroy', on: :member
  end

  resources :users, only: [:update, :edit, :show, :index]

  resources :vacancies, except: [:destroy]

  resources :companies

  resources :candidates, except: [:destroy]

end