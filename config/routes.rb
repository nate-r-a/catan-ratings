Rails.application.routes.draw do
  get 'players/show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :games, param: :number
  resources :players, param: :name
end
