Rails.application.routes.draw do
  devise_for :users

  resources :recipes
  resources :foods
  resources :public_recipes
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  devise_scope :user do
    delete '/users/sign_out', to: 'devise/sessions#destroy'
  end


  # Defines the root path route ("/")
  root to: 'home#index'
  get '/shoppings/:id', to: 'shoppings#index', as: 'shopping'
  get '/shoppings', to: 'shoppings#all', as: 'shoppings'
  delete '/ingredients/:id', to: 'recipes#destroy_ingredient', as: 'destroy_ingredient'
end
