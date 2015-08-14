Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout' }, controllers: { invitations: 'devise/invitations' }

  root 'stickers#index'

  resources :stickers

  get 'archives/:object_name', to: 'archives#index', as: :archives
  delete 'archives/:object_name/:id', to: 'archives#destroy', as: :restore_object

  resources :users, only: [:update, :edit, :show, :index]

  resources :vacancies, except: [:destroy] do
    member  do
      get 'search_candidates_by_status', to: 'vacancies#search_candidates_by_status'
      post 'change_candidate_status', to: 'vacancies#change_candidate_status'
      post 'mark_candidates_as_found', to: 'vacancies#mark_candidates_as_found'
    end
  end

  resources :companies
  resources :candidates, except: [:destroy]
  resources :events, except: [:show]

end