class HomeController < ApplicationController
  def index
    session[:twitter_name] = "asktwoups"
    if (!session[:twitter_name].nil? && !session[:twitter_name].empty?)
      @user = User.find_by_twitter_name(session[:twitter_name])
      @user.groups.each do |ug|
        ug.sub_groups = ug.populate_sub_group
      end
    end
  end
  
  def search
    @results = Search.search(params[:search])

#    @group = Group.find_by_name(params[:search]["query"])
#    if !@group.nil?
#      redirect_to :controller => "groups", :action => "#{@group.name}"
#    else
    
    respond_to do |format|
      format.html 
      format.json  { render :json => @results.to_json }
      format.js { render :partial=> "results" }
    end
#    end
  end
end
