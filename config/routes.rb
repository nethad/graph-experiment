Rails.application.routes.draw do
  resources :graphs, only: [:index]

  namespace :api do
    resource :data
  end

  root to: 'graphs#index'
end
