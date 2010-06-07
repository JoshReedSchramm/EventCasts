EventCasts::Application.routes.draw do |map|
  root :to=>'home#index'
  match '/events/show/:id', :to=>'events#show', :as=>'event_page'  
  match ':controller(/:action(/:id(.:format)))'

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
  match '/:id', :to=>"events#show/:id"    
end
