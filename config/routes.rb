Rails.application.routes.draw do
# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/users/index'

  namespace 'api' do
    namespace 'v1' do
      resources :ticker

      get  "fetch_ticker"  => "ticker#get_with_create"

      get  "fetch_past_ticker"  => "past_ticker#index"
    end
  end
end
