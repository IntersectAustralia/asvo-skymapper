AsvoSkymapper::Application.routes.draw do
  get "job_details/view"
  get "job_details/cancel"

  devise_for :users, controllers: {registrations: 'user_registers', passwords: 'user_passwords' }
  devise_scope :user do
    get '/users/profile', :to => 'user_registers#profile' #page which gives options to edit details or change password
    get '/users/edit_password', :to => 'user_registers#edit_password' #allow users to edit their own password
    put '/users/update_password', :to => 'user_registers#update_password' #allow users to edit their own password
  end

  resources :users, :only => [:show] do

    collection do
      get :access_requests
      get :index
      get :admin
    end

    member do
      put :reject
      put :reject_as_spam
      put :deactivate
      put :activate
      get :edit_role
      put :update_role
      get :edit_approval
      put :approve
    end

  end

  root :to => 'search#index'

  get 'pages/home'

  # Search routes
  get '/search', to: 'search#index'
  get '/search/radial', to: 'search#radial_search', as: 'radial_search'
  get '/search/radial/results', to: 'search#radial_search_results', as: 'radial_search_results'
  get '/search/radial/details/:id', to: 'search#radial_search_details', as: 'radial_search_details'
  get '/search/radial/query', to: 'search#radial_query', as: 'radial_query'
  get '/search/rectangular', to: 'search#rectangular_search', as: 'rectangular_search'
  get '/search/rectangular/results', to: 'search#rectangular_search_results', as: 'rectangular_search_results'
  get '/search/rectangular/details/:id', to: 'search#rectangular_search_details', as: 'rectangular_search_details'
  get '/search/rectangular/query', to: 'search#rectangular_query', as: 'rectangular_query'
  get '/search/raw-image', to: 'search#raw_image_search', as: 'raw_image_search'
  get '/search/raw-image/results', to: 'search#raw_image_search_results', as: 'raw_image_search_results'
  get '/search/raw-image/details/:id', to: 'search#raw_image_search_details', as: 'raw_image_search_details'
  get '/search/bulk-catalogue', to: 'search#bulk_catalogue_search', as: 'bulk_catalogue_search'
  post '/search/bulk-catalogue/validate', to: 'search#bulk_catalogue_validate', as: 'bulk_catalogue_validate'
  get '/search/bulk-catalogue/query', to: 'search#bulk_catalogue_query', as: 'bulk_catalogue_query'
  get '/search/bulk-image', to: 'search#bulk_image_search', as: 'bulk_image_search'
  post '/search/bulk-image/validate', to: 'search#bulk_image_validate', as: 'bulk_image_validate'
  get '/search/bulk-image/results', to: 'search#bulk_image_search_results', as: 'bulk_image_search_results'
  get '/search/bulk-image/results/progress', to: 'search#bulk_image_search_progress', as: 'bulk_image_search_progress'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
