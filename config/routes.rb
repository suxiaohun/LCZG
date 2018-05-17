Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  get '/items'=>'visitors#index'

  root 'orders#index'

  get 'index' => 'home#index'

  get 'login' => 'login#login'

  post 'login' => 'login#login'


  resources :users

  get '/inventories/print_inventory'=>'inventories#print_inventory'
  get '/inventories/inv_records'=>'inventories#inv_records'


  resources :inventories

  get '/goods/get_good_by_id'=>'goods#get_good_by_id'

  resources :goods

  resources :customers


  get '/orders/get_goods'=>'orders#get_goods'
  get '/orders/print_pre'=>'orders#print_pre'
  get '/orders/test'=>'orders#test'

  resources :orders



end
