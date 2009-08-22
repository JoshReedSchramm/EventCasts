class UserController < ApplicationController
  def home
    session[:twitter_name]='JoshReedSchramm'
    @user = User.find(:first, :conditions=>['twitter_name=?', session[:twitter_name]])
  end  
end
