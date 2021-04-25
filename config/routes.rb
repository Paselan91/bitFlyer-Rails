Rails.application.routes.draw do
# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/users/index'

  resources :ticker, only: %i[index new]
end
