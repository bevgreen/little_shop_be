Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  get "/api/v1/items/find", to: "api/v1/items/search#find"
  get "/api/v1/merchants/find_all", to: "api/v1/merchants/search#find_all"

  get "/api/v1/merchants", to: "api/v1/merchants#index" 
  get "api/v1/items", to: "api/v1/items#index"

  get "/api/v1/merchants/:id", to: "api/v1/merchants#show"
  post "/api/v1/merchants", to: "api/v1/merchants#create"
  get "/api/v1/items/:id", to: "api/v1/items#show"
  post "/api/v1/items", to: "api/v1/items#create"


  get "/api/v1/merchants/:id/items", to: "api/v1/merchants/items#index"
  get "/api/v1/items/:id/merchant", to: "api/v1/items/merchant#index"

  patch "/api/v1/merchants/:id", to: "api/v1/merchants#update"
  patch "/api/v1/items/:id", to: "api/v1/items#update"
  #Optional: could implement separate route for put w/ items (but not req'd)
  # put "/api/v1/items/:id", to: "api/v1/items#update"
  delete "/api/v1/merchants/:id", to: "api/v1/merchants#destroy"
  delete "/api/v1/items/:id", to: "api/v1/items#destroy"

  get "/api/v1/merchants/:merchant_id/customers", to: "api/v1/merchant_customers#index"
  get "/api/v1/merchants/:merchant_id/invoices", to: "api/v1/merchant_invoices#index" # moved this into solo project section but may mess up previous tests

  #routes for solo project coupons 
  get "api/v1/merchants/:merchant_id/coupons", to: "api/v1/merchant_coupons#index" #getting all coupons for a specific merchant
  get "api/v1/coupons", to: "api/v1/merchant_coupons#index" #for filtering coupons by status
  get "api/v1/coupons/:id", to: "api/v1/merchant_coupons#show"
  patch "/api/v1/merchants/:merchant_id/invoices/:id", to: "api/v1/merchant_invoices#update"
  post "/api/v1/coupons", to: "api/v1/merchant_coupons#create"
  patch "api/v1/coupons/:id", to: "api/v1/merchant_coupons#update"


end
