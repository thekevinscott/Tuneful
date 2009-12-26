ActionController::Routing::Routes.draw do |map|
  map.resources :stations

  map.root :controller => 'stations', :action => 'index'
  
  map.connect 'station/:url/:action', :controller => 'stations', :action => 'show'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
