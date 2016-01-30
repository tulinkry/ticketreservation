Rails.application.routes.draw do

  root 'secured/dashboard#index'

  namespace :admin do
    get '/', controller: 'schemas', action: :index
    resources :schemas
    put 'schemas/:schema_id/seat/:id', controller: 'seats', action: :change_state, as: 'seat_change_state'
  end


  # namespace :admin do
  #   get '/', action: 'index', as: ''
  #   put ':seat/state', action: 'change_state', as: 'change_state'
  #   get ':id', action: 'show', as: 'show'
  #   get ':id/edit', action: 'edit', as: 'edit'
  #   post ':id/edit', action: 'edit', as: 'edit_post'
  # end


  # namespace :schema do
  #   get 'new', action: 'new', as: 'new'
  #   post 'new', action: 'new', as: 'new_post'
  #   get ':id', action: 'show', as: 'show'
  # end
  
  # namespace :ticket do
  #   post 'close', action: 'close', as: 'close'
  #   post ':seat', action: 'add', as: 'add'
  #   delete ':seat', action: 'del', as: 'del'
  #   delete ':id/seat/:seat', action: 'delete_seat', as: 'delete_seat'
  #   get ':id', action: 'show', as: 'show'
  # end


  scope module: 'secured' do
    resources :schemas, only: [:index, :show]
    resources :tickets, only: [:index, :show, :destroy] do
      resources :seats, only: [:destroy]
    end

    get 'dashboard/index', controller: 'schemas', action: :index, as: 'home'
    post 'ticket/close', controller: 'base', action: 'virtual_ticket_close', as: 'virtual_ticket_close'
    post 'ticket/:seat', controller: 'base', action: 'virtual_ticket_add_seat', as: 'virtual_ticket_add_seat'
    delete 'ticket/:seat', controller: 'base', action: 'virtual_ticket_delete_seat', as: 'virtual_ticket_delete_seat'

  end  

  scope module: 'front' do
    get 'welcome/index', controller: 'welcome', action: :index, as: 'login'
    get 'cron/update', controller: 'cron', action: 'update', as: 'reservation_timeout'
  end
  
  devise_for :users

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
