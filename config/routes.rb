Rails.application.routes.draw do
  devise_for :users
  root 'dashboard#index'
  scope :api, defaults: { format: :json } do
    #users
    get '/users/:id', to: 'api/users#show'
    get '/users', to: 'api/users#index'
    #transactions
    get '/transactions', to: 'api/transactions#index'
    post '/transactions', to: 'api/transactions#create'
    put '/transactions/:id', to: 'api/transactions#update'
    put '/transactions/:id/return', to: 'api/transactions#return'
    get '/transactions/:id', to: 'api/transactions#show'
    #books
    get '/books', to: 'api/books#index'
  end
end
