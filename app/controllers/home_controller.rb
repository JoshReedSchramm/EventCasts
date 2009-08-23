class HomeController < ApplicationController
  def index
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
