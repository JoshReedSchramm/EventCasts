ActionController::Routing::Routes.draw do |map|
  map.connect '/groups/new', :controller=>"groups", :action=>"create", :conditions => { :method => :post}      
  map.connect '/groups/new', :controller=>"groups", :action=>"new", :conditions => { :method => :get}          
  map.connect '/groups/new/:parent_id', :controller=>"groups", :action=>"new"  
  map.connect '/groups/*group_names', :controller=>"groups", :action=>"show"
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
