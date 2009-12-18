class UserController < ApplicationController
  def login
    if request.post?
      user = User.authenticate(params[:user][:username], params[:user][:password])
      if user.nil?
        flash[:notice] = "Unable to find a user with that username and password."
      else
        session[:id] = user.id
        redirect_to :controller=>"user", :action=>"home"
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
end
