EventCasts::Application.routes.draw do |map|
  root :to=>'home#index'

  match '/about_us', :to=>"home#about_us"
  match '/events/new', :to=>"events#create", :via => [:post]
  match '/events/show', :to=>"events#show"
  match '/events/vips/:event_id', :to=>"events#vips", :via => [:get]
  match '/events/participants/:event_id', :to=>"events#participants", :via => [:get]
  match '/events/new', :to=>"events#new", :via => [:get]         
  match '/events/add_event_vip', :to=>"events#add_event_vip"
  match '/events/new', :to => "events#new"
  match '/user/events/:twitter_name', :to=>"user#events/:twitter_name"  
  match '/user/register', :to=>"user#register", :via=>[:post]  
  match '/user/login/:user', :to=>"user#login", :via=>[:post]    
  match '/user/verify_login', :to=>"user#verify_login"
  match '/user/home', :to=>"user#home"
  match '/user/:action', :to=>"user"
  match '/home/search', :to=>"home#search"  
  match '/home/:action/:id', :to=>"home(/:action(/:id))"  
  match '/messages/persist/:_json', :to=>"messages#persist"
  match '/messages/:action/:id', :to=>"messages(/:action(/:id))"    
  match '/events/*event_names', :to=>"events#show/*event_names"  
  match '/:id', :to=>"events#show/:id"    
end
