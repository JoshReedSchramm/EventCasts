class HomeController < ApplicationController
  def index
    if (!session[:twitter_name].nil? && !session[:twitter_name].empty?)
      @user = User.find_by_twitter_name(session[:twitter_name])
      @user.groups.each do |ug|
        ug.sub_groups = ug.populate_sub_group
      end
    end
  end
  
  def search
    @results = Search.search(params[:search])
    render :partial=> "search", :layout => false
  end
end
