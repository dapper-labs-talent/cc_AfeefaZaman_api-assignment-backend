Rails.application.routes.draw do
  resources :athletes, only: :index
end
