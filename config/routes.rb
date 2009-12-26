ActionController::Routing::Routes.draw do |map|
  map.resources :stations

  map.root :controller => 'tuneful', :action => 'index'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
