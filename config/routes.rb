Rails.application.routes.draw do
  # get '/birds', to: 'birds#index'
  # get '/birds/:id', to: 'birds#show'
  resources :birds, only: [:index, :show]
end
