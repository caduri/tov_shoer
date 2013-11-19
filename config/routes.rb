TovShoer::Application.routes.draw do
  get "arenas/create"
  get "players/show"
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "registrations" }

  resources :players

  root to: "home#index"
end
