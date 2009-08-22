# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  rescue_from Twitter::Unauthorized, :with => :twitter_unauthorized

  private
    def twitter_unauthorized(exception)
      flash[:notice] = "Unathorized. Please log in again."
      redirect_to :controller => :home, :action => :index
    end
end
