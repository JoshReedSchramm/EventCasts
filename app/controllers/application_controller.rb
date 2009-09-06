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
    unless Security.is_authenticated?(session[:twitter_name])
      redirect_to(:controller=>"home", :action=>"index")
      false
    end
  end

  private
    def twitter_unauthorized(exception)
      flash[:notice] = "Unable to update at the moment. Twitter may be down or you may need to log in again."
      redirect_to :controller => :home, :action => :index
    end
end
