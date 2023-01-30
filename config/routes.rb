Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      get "parking_lot/:parking_lot_name/spots_remaining", to: "parking_lot#spots_remaining", as: :spots_remaining
      get "parking_lot/:parking_lot_name/spots_taken/(:vehicle_type)", to: "parking_lot#spots_taken", as: :spots_taken
      get "parking_lot/:parking_lot_name/parking_available/:vehicle_type", to: "parking_lot#parking_available", as: :parking_available
      get "parking_lot/:parking_lot_name/is_full", to: "parking_lot#is_full", as: :is_full
      post "parking_lot/:parking_lot_name/park", to: "parking_lot#park", as: :park
      delete "parking_lot/:parking_lot_name/remove/:vehicle_plate", to: "parking_lot#remove", as: :remove
    end
  end
end
