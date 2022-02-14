Rails.application.routes.draw do
  resources :ip_locations
  apipie
  root to: 'visitors#index'
  devise_for :users, path: "", controllers: { omniauth_callbacks: "omniauth_callbacks" ,registrations: "registrations", sessions: "sessions"}, path_names: { sign_in: 'login', password: 'forgot', sign_up: 'register', sign_out: 'signout'}
  resources :users
  resources :parking_places

  get '/auth/:provider/callback', to: 'sessions#create'
  
  #users
  get '/subscription_for/:plan', to: 'users#subscription_for'
  post 'make_payment', to: 'users#make_payment'
  get 'payment_status', to: 'users#payment_status'
  get 'my_profile' => 'users#my_profile', as: 'my_profile'
  get 'fill_address_details' => 'users#fill_address_details'
  put 'update_address_details' => 'users#update_address_details'

  #visitors
  get 'visitors/get_coordinate', to: 'visitors#get_coordinate'
  get 'about_us' => 'visitors#about_us', as: 'about_us'
  get 'parking_places_list' => 'visitors#parking_places_list', as: 'parking_places_list'
  get 'subscriptions' => 'visitors#subscriptions', as: 'subscriptions'

  #parking places
  get 'search_result' => 'parking_places#search_result', as: 'search_result'
  get 'my_parking_place' => 'parking_places#my_parking_place', as: 'my_parking_place'
  
  #api routes
  namespace :api do
    namespace :v1 do
      resource :users, only: [] do
        post  'user_signup'
        post  'user_signin'
        post  'login_with_social_network'
        post  'add_feedback'
        post  'track_ip'
      end
      resource :parking_places, only: [] do
        get   'get_all_parking_places'
        post  'add_parking_place'
        post  'update_parking_place_details'
        get   'destroy_parking_place'
        get   'search_parking_places'
        get   'parking_place_details'
        get   'check_parking_place_availability'
      end
      resource :bookings, only: [] do
        post  'create_booking'
      end
    end
  end
end
