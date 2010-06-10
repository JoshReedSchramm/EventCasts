module AuthenticationHelpers    
  protected
    def authenticate
      deny_access unless authorized?
    end
  
    def authorized?
      return !logged_in_user.nil?
    end

    def logged_in_user
      session[:user]
    end
    
    def deny_access
      store_location
      flash[:notice] = 'You must be logged in to view that page.'      
      render :template => "/user/login", :status => :unauthorized
    end
    
    def sign_in(profile)
      session[:screen_name] = profile.screen_name if profile
    end

    def redirect_back_or(default)
      session[:return_to] ||= params[:return_to]
      if session[:return_to]
        redirect_to(session[:return_to])
      else
        redirect_to(default)
      end
      session[:return_to] = nil
    end

    def store_location
      session[:return_to] = request.fullpath if request.get?
    end
end