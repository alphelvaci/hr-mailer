Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get 'celebration-events/', to: 'celebration_events#index'
  get 'celebration-events/:id/retry', to: 'celebration_events#retry'
end
