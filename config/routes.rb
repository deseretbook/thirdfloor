Rails.application.routes.draw do
  resources :dashboard_cells do
    member do
      post '/' => :update
    end
  end

  resources :dashboards do
    member do
      post :add_visualization
      post :remove_visualization
      get :updates
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  get '/browserconfig.xml' => redirect('/404')

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  resources :user_locations, only: [ :index, :create, :show ]

  resources :users, only: [ :index ] do
    collection do
      get 'log_in'
      post 'authenticate'
      get 'log_out'
    end
  end

  resources :stations

  resources :travis, only: [ :index ]
  get '/travis/*repo_string' => 'travis#show'

  resources :data_points, only: [ :index, :show, :create, :destroy ]
  post 'data_points/:name' => 'data_points#named_route_create'

  get '/visualize/:slug' => 'home#visualize', as: 'render_visualization'
  get '/dashboard/:slug' => 'home#dashboard', as: 'render_dashboard'
  get '/dashboard/' => 'home#default_dashboard', as: 'render_default_dashboard'

  resources :visualizations

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
