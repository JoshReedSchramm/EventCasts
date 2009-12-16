class HomeController < ApplicationController
  def index
    if (!session[:twitter_name].nil? && !session[:twitter_name].empty?)
      @user = User.find_by_twitter_name(session[:twitter_name])
    end

    if request.post?
      @auto_search = true
      @search_term = params[:search][:query]
    end
  end
  
  def search
    @results = Search.search(params[:search])
  end
  
  def about_us
    if (!session[:twitter_name].nil? && !session[:twitter_name].empty?)
      @user = User.find_by_twitter_name(session[:twitter_name])
    end    
  end
end
