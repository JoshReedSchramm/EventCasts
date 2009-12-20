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
      @user = User.new(params[:user])
      @user.save
    end
  end

  def logout
    session[:username] = nil
    redirect_to "/"
  end
  
  def events
    @user = User.find_by_twitter_name(params[:twitter_name])    
    render :partial=>"user_events", :layout => false
  end
  
  def verify_login
    if session[:user].nil?
      render :partial=>"login", :layout=>false
    else
      render :text => "true", :layout=>false
    end
  end
  
  def ajax_authentication_failure()
    if request.xhr?
      response.headers['X-JSON'] = {:username=>"The username or password entered did not match a valid user."}.to_json
      render :nothing => true, :status=>444   
      return true     
    end
    return false
  end
end
