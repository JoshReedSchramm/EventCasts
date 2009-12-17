ActionController::Routing::Routes.draw do |map|
  map.connect '/', :controller=>'home'
  
  map.connect '/about_us', :controller=>"home", :action=>"about_us"
  map.connect '/events/new', :controller=>"events", :action=>"create", :conditions => { :method => :post}      
  map.connect '/events/vips/:event_id', :controller=>"events", :action=>"vips", :conditions => { :method => :get}        
  map.connect '/events/participants/:event_id', :controller=>"events", :action=>"participants", :conditions => { :method => :get}          
  map.connect '/events/new', :controller=>"events", :action=>"new", :conditions => { :method => :get}          
  map.connect '/events/add_event_vip', :controller=>"events", :action=>"add_event_vip"
  map.connect '/events/new', :controller=>"events", :action=>"new"
  map.connect '/events/set_data', :controller=>"events", :action=>"set_data", :conditions => { :method => :post}            
  map.connect '/events/:action/:id', :controller=>"events"
  map.connect '/user/events/:twitter_name', :controller=>"user", :action=>"events"  
  map.connect '/user/:action/:id', :controller=>"user"  
  map.connect '/home/:action/:id', :controller=>"home"  
  map.connect '/events/*event_names', :controller=>"events", :action=>"show"  
  map.connect '/:id', :controller=>"events", :action=>"show"    
end
