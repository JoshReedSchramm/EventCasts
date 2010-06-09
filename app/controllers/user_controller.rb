class UserController < ApplicationController
  def login
    if request.post?
      user = User.authenticate(params[:user][:username], params[:user][:password])
      if user.nil?        
        flash[:notice] = "Unable to find a user with that username and password."
        ajax_authentication_failure()
      else
        session[:user] = user
        if !request.xhr?
          redirect_to :controller=>"user", :action=>"home"
        end
      end
    end
  end
  
  def home
    if !session[:id].nil?
      @user = User.find_by_id(session[:id])
    else
      flash[:notice] = "You must be logged in to view that page."
      redirect_to :controller=>"home", :action=>"index"
    end        
  end
  
  def register
    if !params[:user].nil?
      user = User.new(params[:user])
      result = user.save
      if result
        session[:user] = user  
        if request.xhr?
          render :text => "true", :layout=>false          
        else
          redirect_to :controller=>"user", :action=>"home"
        end
      elsif request.xhr?
        handle_ajax_validation_errors(user)
      end
    end
  end

  def logout
    session[:username] = nil
    redirect_to "/"
  end
  
  def events
    @user = User.find_by_ec_username(params[:ec_username])    
    render :partial=>"user_events", :layout => false
  end
  
  def verify_login
    if session[:user].nil?
      render :partial=>"login", :layout=>false
    else
      render :text => "true", :layout=>false
    end
  end
  
  def attach_twitter
      oauth.set_callback_url(finalize_twitter_session_url)

      session['rtoken']  = oauth.request_token.token
      session['rsecret'] = oauth.request_token.secret

      redirect_to oauth.request_token.authorize_url
  end
  
  def finalize_twitter
    oauth.authorize_from_request(session['rtoken'], session['rsecret'], params[:oauth_verifier])

    profile = Twitter::Base.new(oauth).verify_credentials
    session['rtoken'] = session['rsecret'] = nil
    session[:atoken] = oauth.access_token.token
    session[:asecret] = oauth.access_token.secret

    session[:user] = profile.screen_name if profile
    redirect_back_or root_path
  end
  
  
  def ajax_authentication_failure()
    if request.xhr?
      response.headers['X-JSON'] = "[[\"username\",\"The username or password entered did not match a valid user\"]]";
      render :nothing => true, :status=>444   
      return true     
    end
    return false
  end
end
