Rails.application.routes.draw do
  resources :graphs, only: [:index]

  root to: 'graphs#index'
end
