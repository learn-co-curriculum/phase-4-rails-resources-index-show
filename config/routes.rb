Rails.application.routes.draw do
  resources :birds, only: [:index, :show]
end
