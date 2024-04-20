Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  devise_for :users

  # Defines the root path route ("/")
  root 'home#index'
  resources :users, only: [:show] do
    resources :bank_accounts, only: [:show] do
      resources :transactions, only: %i[create]
    end
  end
end
