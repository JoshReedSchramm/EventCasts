class UserController < ApplicationController
  def login
  end
  
  def register
    @user = User.new(params[:user])
    @user.save
  end

  def logout
    session[:twitter_name] = nil
    redirect_to "/"
  end
  
  def events
    @user = User.find_by_twitter_name(params[:twitter_name])    
    render :partial=>"user_events", :layout => false
  end

  def authorize
  end

  def handle_failed_authorization
    flash[:notice] = "Authentication failed"
    redirect_to :controller => :home, :action => :index
  end
 end
