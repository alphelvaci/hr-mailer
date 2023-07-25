Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get 'logs/', to: 'logs#index'
  get 'logs/:id/retry', to: 'logs#retry'
end
