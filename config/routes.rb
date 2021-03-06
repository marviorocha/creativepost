Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

root to: "home#index"

get "home/search", to: "home#search"

post "home/post/:id", to: "home#post", as: "post"
get "home/show/:id", to: "home#show", as: "show"

# Partituras Resorce
resources :partituras do
  collection do
    get "partituras/search", to: "partituras#search"
    delete 'destroy_multiple'
  end
end



end
