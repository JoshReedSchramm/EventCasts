ActionController::Routing::Routes.draw do |map|
  map.root :controller=>'home'
  
  map.connect '/groups/new', :controller=>"groups", :action=>"create", :conditions => { :method => :post}      
  map.connect '/groups/new', :controller=>"groups", :action=>"new", :conditions => { :method => :get}          
  map.connect '/groups/new/:parent_id', :controller=>"groups", :action=>"new"  
  map.connect '/groups/subgroups/:id', :controller=>"groups", :action=>"subgroups", :conditions => { :method => :get}              
  map.connect '/groups/set_data/*group_names', :controller=>"groups", :action=>"set_data", :conditions => { :method => :post}            
  map.connect '/user/:action/:id', :controller=>"user"
  map.connect '/home/:action/:id', :controller=>"home"  
  map.connect '/groups/*group_names', :controller=>"groups", :action=>"show"  
  map.connect '/*group_names', :controller=>"groups", :action=>"show"    
end
