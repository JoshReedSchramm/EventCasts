class ApplicationController < ActionController::Base
  
  helper :all
  protect_from_forgery
  layout 'application'
  
  rescue_from Twitter::Unauthorized, :with => :force_sign_in
  
  def handle_ajax_validation_errors(object)
    if !object.errors.empty? && request.xhr?
      set_ajax_validation_errors(object.errors.to_json)
      return true     
    end
    return false
  end

  def set_ajax_validation_errors(errors)
    response.headers['X-JSON'] = errors
    render :nothing => true, :status=>444       
  end  

  def authorize 
    if !authorized?
      flash[:notice] = "You must be logged in to view that page."        
      redirect_to :controller => :user, :action => :login
    end
  end
  
  private
    def oauth
      @oauth ||= Twitter::OAuth.new(ConsumerToken, ConsumerSecret, :sign_in => true)
    end

    def client
      oauth.authorize_from_access(session[:atoken], session[:asecret])
      Twitter::Base.new(oauth)
    end
    helper_method :client  
  
    def authorized?
      return !logged_in_user.nil?
    end

    def logged_in_user
      session[:user]
    end

    def render_404
      render :file => "#{Rails.root}/public/404.html",  :status => 404
    end
  
    def force_sign_in(exception)
      flash[:error] = 'You must be signed into twitter to use this feature. Please sign in again.'
    end
end
