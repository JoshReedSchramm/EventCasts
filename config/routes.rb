ActionController::Routing::Routes.draw do |map|
  map.connect '/:controller/new', :action=>"create", :conditions => { :method => :post}  
  map.connect '/groups/*group_names', :controller=>"groups", :action=>"show"
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
