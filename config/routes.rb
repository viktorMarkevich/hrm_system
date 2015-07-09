Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout' }, controllers: { invitations: 'devise/invitations' }

  root 'stickers#index'

  resources :stickers, except: [:show]
  get 'restore_stickers' => 'stickers#restore_sticker'

  resources :users, only: [:update, :edit, :show, :index]

  resources :vacancies, except: [:destroy]
  post '/vacancies/search_candidates_by_status', to: 'vacancies#search_candidates_by_status', as: 'vacancy_candidates'
  post 'vacancies/change_candidate_status', to: 'vacancies#change_candidate_status'
  resources :companies

  resources :candidates, except: [:destroy]

end