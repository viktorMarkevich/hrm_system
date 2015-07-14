Rails.application.routes.draw do

  resources :events
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout' }, controllers: { invitations: 'devise/invitations' }

  root 'stickers#index'

  resources :stickers
  put 'status_sticker' => 'stickers#status_sticker'

  get 'archives/:object_name', to: 'archives#index', as: :archives
  delete 'archives/:object_name/:id', to: 'archives#destroy', as: :restore_object

  resources :users, only: [:update, :edit, :show, :index]

  resources :vacancies, except: [:destroy]

  resources :companies

  resources :candidates, except: [:destroy]

end