class HomeController < ApplicationController
  def index
  end
  
  def search
    @results = Search.search(params[:search])
    render :partial=> "search", :layout => false
  end
end
