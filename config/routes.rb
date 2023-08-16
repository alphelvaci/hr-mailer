Rails.application.routes.draw do
  devise_for :admins, path_names: { sign_in: 'login', sign_out: 'logout' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get '', to: redirect('celebration-events/')
  get 'celebration-events/', to: 'celebration_events#index'
  get 'celebration-events/:id/retry', to: 'celebration_events#retry'
end
