ActionController::Routing::Routes.draw do |map|
  
  map.resources :users
  map.resources :tracks
  map.resources :errors
  map.resources :stations
  map.resources :interested_parties
  
  
  
  map.root :controller => 'stations', :action => 'index'
  
  map.login '/login', :controller => 'users', :action => 'login'
  map.register '/register', :controller => 'users', :action => 'register'
  map.logout '/logout', :controller => 'users', :action => 'logout'
  map.invites '/invites', :controller => 'users', :action => 'invites'
  
  map.connect 'station/:url/:action', :controller => 'stations', :action => 'show'
  map.connect 'station/:url/:action/:id', :controller => 'stations', :action => 'show'

  map.connect 'tracks/upload/:artist/:track', :controller => 'tracks', :action => 'upload'
  map.connect 'tracks/test', :controller => 'tracks', :action => 'test'


  map.connect ':controller/:action/'
  map.connect ':controller/:action.:format'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

end
