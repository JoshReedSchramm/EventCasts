EventCasts::Application.routes.draw do |map|
  root :to=>'home#index'
  match '/event/show/:id', :to=>'event#show', :as=>'event_page'  

  match '/user/login/:user', :to=>"user#login", :via=>[:post]    
  match '/messages/persist/:_json', :to=>"messages#persist"  
  match '/messages/:action/:id', :to=>"messages(/:action(/:id))"    
  
  match ':controller(/:action(/:id(.:format)))'
  match '/:id', :to=>"events#show/:id"    
  
  match 'associated_account/start_twitter', :to => 'associated_account#start_twitter', :as => 'start_twitter_session'  
  match 'associated_account/finalize_twitter', :to => 'associated_account#finalize_twitter', :as => 'finalize_twitter_session'
  
  match 'associated_account/add', :to => 'associated_account#add', :as => 'associate_account'
end
