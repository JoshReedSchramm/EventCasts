class HomeController < ApplicationController
  def index
    session[:twitter_name] = 'JoshReedSchramm'
    if (!session[:twitter_name].nil? && !session[:twitter_name].empty?)
      @user = User.find_by_twitter_name(session[:twitter_name])
      @user.groups.each do |ug|
        ug.sub_groups = ug.populate_sub_group
      end
      @sub_groups = @user.groups
      @parent_check_id= 0
    end

    if request.post?
      @auto_search = true
      @search_term = params[:search][:query]
    end
  end
  
  def search
    @results = Search.search(params[:search])
    render :partial=> "search", :layout => false
  end
  
  def about_us
    if (!session[:twitter_name].nil? && !session[:twitter_name].empty?)
      @user = User.find_by_twitter_name(session[:twitter_name])
      @user.groups.each do |ug|
        ug.sub_groups = ug.populate_sub_group
      end
    end    
  end
end
