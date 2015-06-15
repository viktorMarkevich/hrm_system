Rails.application.routes.draw do
  root 'stickers#index'

  resources :stickers
end
