class UserController < ApplicationController
  def login
    if request.post?
      user = User.authenticate(params[:user][:username], params[:user][:password])
      if user.nil?
        flash[:notice] = "Unable to find a user with that username and password."
      else
        session[:username] = user.username
        redirect_to :controller=>"user", :action=>"home"
      end
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
