ActionController::Routing::Routes.draw do |map|
  map.connect '/:controller/new', :action=>"create", :conditions => { :method => :post}  
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
