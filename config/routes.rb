Rails.application.routes.draw do
  devise_for :users

  root 'stickers#index'

  resources :stickers, except: [:show]

  resources :users, only: [:update, :edit, :show]

  resources :vacancies, except: [:destroy]

  resources :companies

  resources :candidates, except: [:destroy]

end
