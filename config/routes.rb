Rails.application.routes.draw do
  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'price_all', to: 'stocks#price_all'
  resources :wallets, only: [:show, :create]
  resources :transactions do
    collection do
      post 'transfer'  # Route for transferring funds
    end
  end
end
