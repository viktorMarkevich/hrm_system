Rails.application.routes.draw do
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  root 'stickers#index'
  resources :stickers, except: [:show]
  resources :vacancies, only: [:new, :edit, :index, :show]
end
