class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  
  def handle_ajax_validation_errors(object)
    if !object.errors.empty? && request.xhr?
      response.headers['X-JSON'] = object.errors.to_json
      render :nothing => true, :status=>444   
      return true     
    end
    return false
  end

  def authorize 
    redirect_to :controller => :user, :action => :login unless authorized?
  end
  
  def authorized?
    return !logged_in_user.nil?
  end

  def logged_in_user
    return session[:user]
  end

  def render_404
    render :file => "#{Rails.root}/public/404.html",  :status => 404
  end
end
