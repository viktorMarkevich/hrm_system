Rails.application.routes.draw do
  root 'stickers#index'

  resources :stickers, except: [:show]
end
