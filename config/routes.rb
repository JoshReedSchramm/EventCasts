EventCasts::Application.routes.draw do |map|
  root :to=>'home#index'
  match '/events/show/:id', :to=>'events#show', :as=>'event_page'  

  match '/user/login/:user', :to=>"user#login", :via=>[:post]    
  match '/messages/persist/:_json', :to=>"messages#persist"  
  match '/messages/:action/:id', :to=>"messages(/:action(/:id))"    
  
  match ':controller(/:action(/:id(.:format)))'
  match '/:id', :to=>"events#show/:id"    
end
