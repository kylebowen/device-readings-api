Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  defaults format: :json do
    resources :readings, only: :create

    get "/devices/:device_uuid/latest_timestamp", to: "devices#latest_timestamp"
    get "/devices/:device_uuid/cumulative_count", to: "devices#cumulative_count"
  end
end
