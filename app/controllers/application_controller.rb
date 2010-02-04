class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  rescue_from Twitter::Unauthorized, :with => :twitter_unauthorized
  
  def handle_ajax_validation_errors(object)
    if !object.errors.empty? && request.xhr?
      response.headers['X-JSON'] = object.errors.to_json
      render :nothing => true, :status=>444   
      return true     
    end
    return false
  end
  
  def authorize 
    redirect_to :controller => :home, :action => :index unless Security.authorized?
  end
  
  def logged_in_user
    return session[:user]
  end
  def authorized?
    return !logged_in_user.nil?
  end
  
  def render_404
    render :file => "#{RAILS_ROOT}/public/404.html",  :status => 404
  end

  private
    def twitter_unauthorized(exception)
      flash[:notice] = "Unable to update at the moment. Twitter may be down or you may need to log in again."
      redirect_to :controller => :home, :action => :index
    end
end
