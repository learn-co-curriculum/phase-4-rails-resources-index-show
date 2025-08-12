Rails.application.routes.draw do
  resources :birds, only: %i[index show]
end
