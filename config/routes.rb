Rails.application.routes.draw do
  
  resources :venues, except: [:new, :edit]
  resources :distributions, except: [:new, :edit] do
    collection do
      get 'by_room_id'
    end
  end
  resources :schedules, except: [:new, :edit] do
    member do
      get 'bookings'
    end
    collection do
      get 'weekly_scope'
    end
  end
  resources :rooms, except: [:new, :edit]
  resources :instructors, except: [:new, :edit]
  resources :appointments, except: [:new, :edit]
  resources :emails, except: [:new, :edit]
  resources :cards, except: [:new, :edit] 

  resources :packs, except: [:new, :edit]
  resources :purchases, except: [:new, :edit]

  mount_devise_token_auth_for 'User', :controllers => {:registrations => "registrations", :sessions => "sessions", :passwords => "passwords"}, defaults: { format: :json }#, :skip => [:registrations]
  
  devise_scope :user do
    match 'users/sign_up', :to => "registrations#create", :via => [:post, :options]
    match 'users/sign_in', :to => "sessions#create", :via => [:post, :options]
    match 'users/password', :to => "passwords#create", :via => [:post, :options]
    match 'users', :to => "registrations#create", :via => [:post, :options]
    get 'logout', :to => "sessions#destroy"
    get 'session', :to => "users#session"
  end

  resources :roles, except: [:new, :edit]
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
