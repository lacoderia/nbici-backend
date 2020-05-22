Rails.application.routes.draw do
  
  resources :streaming_classes, only: [:index, :show]
  resources :available_streaming_classes, only: :index do
    collection do
      match 'purchase', to: "available_streaming_classes#purchase", via: [:post, :options]
    end
  end
  resources :promotion_amounts
  resources :promotions
  resources :configurations
  resources :referrals
  resources :expirations
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
      match 'book_and_charge', :to => "appointments#book_and_charge", :via => [:post, :options]
      get 'weekly_scope_for_user', :to => 'appointments#weekly_scope_for_user'
      get 'historic_for_user', :to => 'appointments#historic_for_user'
    end
    member do
      get 'cancel', :to => "appointments#cancel"
      match 'edit_bicycle_number', :to => "appointments#edit_bicycle_number", :via => [:post, :options]
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
  resources :menu_items, except: [:new, :edit]
  resources :menu_categories, except: [:new, :edit]

  resources :menu_purchases do
    collection do
      match 'charge', :to => "menu_purchases#charge", :via => [:post, :options]
    end
  end

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
    get 'logout', :to => "sessions#destroy"
    get 'session', :to => "sessions#get"
  end
  
  resources :users do
    member do
      match 'send_coupon_by_email', :to => "users#send_coupon_by_email", :via => [:post, :options]
    end
    collection do
      #Called from the front end 
      match 'remote_authenticate', :to => 'users#remote_authenticate', :via => [:post, :options]
      match 'synchronize_accounts', :to => 'users#synchronize_accounts', :via => [:post, :options]
      #Called from system to system
      match 'validate_email', :to => 'users#validate_email', :via => [:post, :options]
      match 'remote_login', :to => 'users#remote_login', :via => [:post, :options]
      match 'update_account', :to => 'users#update_account', :via => [:post, :options]
      #Nbici unique methods
      match 'receive_classes_left', :to => 'users#receive_classes_left', :via => [:post, :options]
      match 'migrate_accounts', :to => 'users#migrate_accounts', :via => [:post, :options]
    end
  end

  resources :roles, except: [:new, :edit]
    
  match 'discounts/validate_with_coupon', :to => "discounts#validate_with_coupon", :via => [:post, :options]
  match 'discounts/validate_with_credits', :to => "discounts#validate_with_credits", :via => [:post, :options]
  
  # root 'welcome#index'
  root to: "admin/dashboard#index"

end
