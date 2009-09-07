ActionController::Routing::Routes.draw do |map|
  map.root :controller=>'home'
  
  map.connect '/about_us', :controller=>"home", :action=>"about_us"
  map.connect '/groups/new', :controller=>"groups", :action=>"create", :conditions => { :method => :post}      
  map.connect '/groups/vips/:group_id', :controller=>"groups", :action=>"vips", :conditions => { :method => :get}        
  map.connect '/groups/participants/:group_id', :controller=>"groups", :action=>"participants", :conditions => { :method => :get}          
  map.connect '/groups/new', :controller=>"groups", :action=>"new", :conditions => { :method => :get}          
  map.connect '/groups/add_group_vip', :controller=>"groups", :action=>"add_group_vip", :conditions => { :method => :post}
  map.connect '/groups/new/:parent_id', :controller=>"groups", :action=>"new"
  map.connect '/groups/subgroups/:id', :controller=>"groups", :action=>"subgroups", :conditions => { :method => :get}              
  map.connect '/groups/set_data/*group_names', :controller=>"groups", :action=>"set_data", :conditions => { :method => :post}            
  map.connect '/groups/:action/:id', :controller=>"groups"
  map.connect '/group_data/:action/:id', :controller=>"group_data"  
  map.connect '/user/groups/:twitter_name', :controller=>"user", :action=>"groups"  
  map.connect '/user/:action/:id', :controller=>"user"  
  map.connect '/home/:action/:id', :controller=>"home"  
  map.connect '/groups/*group_names', :controller=>"groups", :action=>"show"  
  map.connect '/*group_names', :controller=>"groups", :action=>"show"    
end
