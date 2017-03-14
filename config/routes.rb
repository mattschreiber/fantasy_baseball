Rails.application.routes.draw do

  root 'seasons#index'
  resources :owners
  resources :players do
    post 'set_starter'
  end
  get 'seasons', to: 'seasons#index'
  get 'seasons/new'
  get 'seasons/projected_standings', to:  'seasons#projected_standings'
  get 'historical', to: 'seasons#historical'
  post 'seasons/import', to: 'seasons#import'
  get 'stats/index'
  get 'stats/compare', to: 'stats#compare'
  get 'owners/:id/teamprojections', to: 'owners#teamprojections', as: 'owners/teamprojections'

  post 'notes', to: 'notes#create'
  get 'watchlist', to: 'notes#watchlist', as: 'notes/watchlist'




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
