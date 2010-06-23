class ApplicationController < ActionController::Base
  include AuthenticationHelpers
  include AjaxHelpers
  
  helper :all
  protect_from_forgery
  layout 'application'
  
  rescue_from Twitter::Unauthorized, :with => :force_sign_in
  
  private
    def oauth
      @oauth ||= Twitter::OAuth.new(ConsumerToken, ConsumerSecret, :sign_in => true)
    end

    def client
      oauth.authorize_from_access(session[:atoken], session[:asecret])
      Twitter::Base.new(oauth)
    end
    helper_method :client  
  
    def render_404
      render :file => "#{Rails.root}/public/404.html",  :status => 404
    end
  
    def force_sign_in(exception)
      flash[:error] = 'You must be signed into twitter to use this feature. Please sign in again.'
      redirect_back_or('/user/login')
    end
end
