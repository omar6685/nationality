Rails.application.routes.draw do
  resources :nationality_reports
  root 'nationality_reports#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
# config/routes.rb
resources :nationality_reports do
  post 'generate_report', on: :collection
end

  # Defines the root path route ("/")
  # root "articles#index"
end
