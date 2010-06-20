module ApplicationHelper
  #include TwitterText::Autolink
  
  def logged_in_user
    @logged_in_user ||= User.find(session[:user].id)
  end      
end
