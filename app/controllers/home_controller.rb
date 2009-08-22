class HomeController < ApplicationController
  def index
  end
  
  def search
    @results = Search.search(params[:search])
    respond_to do |format|
      format.html 
      format.json  { render :json => @results.to_json }
      format.js { render :partial=> "results" }
    end
  end
end
