class UserController < ApplicationController
  include UserHelper
  before_filter :authenticate, :except=>[:login, :register, :verify_login, :start_twitter, :finalize_twitter]
  
  def login
    store_location
    if request.post?
      session[:user] = User.authenticate(params[:user][:ec_username], params[:user][:password])
      if session[:user].nil?        
        authentication_failure()
      else
        redirect_to :controller=>"user", :action=>"home" if !request.xhr?
      end
    end
  end
    
  def register
    store_location
    if !params[:user].nil?
      @user = User.new(params[:user])
      result = @user.save
      if result
        session[:user] = @user  
        if request.xhr?
          render :text => "true", :layout=>false          
        else
          redirect_to :controller=>"user", :action=>"home"
        end
      elsif request.xhr?
        handle_ajax_validation_errors(@user)
      end
    end
  end

  def logout
    session[:user] = nil
    redirect_to "/"
  end
  
  def verify_login
    if session[:user].nil?
      render :partial=>"login", :layout=>false
    else
      render :text => "true", :layout=>false
    end
  end
    
  def start_twitter
      oauth.set_callback_url(finalize_twitter_session_url)

      session['rtoken']  = oauth.request_token.token
      session['rsecret'] = oauth.request_token.secret

      redirect_to oauth.request_token.authorize_url
  end
  
  def finalize_twitter
    oauth.authorize_from_request(session['rtoken'], session['rsecret'], params[:oauth_verifier])
    profile = Twitter::Base.new(oauth).verify_credentials            
    
    if profile        
      session['rtoken'] = session['rsecret'] = nil
      session[:atoken] = oauth.access_token.token
      session[:asecret] = oauth.access_token.secret

      session[:user] = User.get_from_twitter(profile)
      redirect_to :controller=>"user", :action=>"home"
    end
  end
  
  def home
    render_user_home_layout
  end  
  
  def events
    render_user_home_layout
  end
  
  def accounts
    render_user_home_layout
  end

  def settings
    render_user_home_layout
  end
  
  private
  
  def render_user_home_layout
    displayed_layout = request.xhr? ? false : "user_home"
    render :layout=>displayed_layout        
  end
  
  def authentication_failure()
    flash[:notice] = "Unable to find a user with that username and password."    
    set_ajax_validation_errors("[[\"username\",\"The username or password entered did not match a valid user\"]]") if request.xhr?
  end
end
