Rails.application.routes.draw do
  
  resources :venues, except: [:new, :edit]
  resources :distributions do
    collection do
      get 'by_room_id'
    end
  end
  resources :schedules do
    member do
      get 'bookings'
    end
    collection do
      get 'weekly_scope'
    end
  end
  resources :rooms, except: [:new, :edit]
  resources :instructors, except: [:new, :edit]
  resources :appointments do
    collection do
      match 'book', :to => "appointments#book", :via => [:post, :options]
      get 'weekly_scope_for_user', :to => 'appointments#weekly_scope_for_user'
      get 'historic_for_user', :to => 'appointments#historic_for_user'
    end
    member do
      get 'cancel', :to => "appointments#cancel"
    end
  end
  resources :emails, except: [:new, :edit]
  resources :cards do 
    collection do
      match 'register_for_user', :to => 'cards#register_for_user', :via => [:post, :options]
      match 'delete_for_user', :to => 'cards#delete_for_user', :via => [:post, :options]
      match 'set_primary_for_user', :to => 'cards#set_primary_for_user', :via => [:post, :options]
      get 'get_primary_for_user', :to => 'cards#get_primary_for_user'
      get 'get_all_for_user', :to => 'cards#get_all_for_user'
    end
  end

  resources :packs, except: [:new, :edit]
  resources :purchases do
    collection do
      match 'charge', :to => "purchases#charge", :via => [:post, :options]
    end
  end
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  mount_devise_token_auth_for 'User', at: 'auth', :controllers => {:registrations => "registrations", :sessions => "sessions", :passwords => "passwords"}, defaults: { format: :json }#, :skip => [:registrations]

  devise_scope :user do
    match 'users/sign_up', :to => "registrations#create", :via => [:post, :options]
    match 'users/sign_in', :to => "sessions#create", :via => [:post, :options]
    match 'users/password', :to => "passwords#create", :via => [:post, :options]
    match 'logout', :to => "sessions#destroy", :via => [:get, :options]
    get 'session', :to => "sessions#get"
  end
  
  resources :users

  resources :roles, except: [:new, :edit]
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root to: "admin/dashboard#index"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
