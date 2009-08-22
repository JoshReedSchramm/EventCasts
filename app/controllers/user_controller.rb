class UserController < ApplicationController
  def home
    session[:twitter_name]='asktwoups'
    @user = User.find_by_twitter_name(session[:twitter_name]) 
  end  
end
