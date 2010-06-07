class HomeController < ApplicationController
  def index
  end
  
  def search
    @results = Search.search(params[:search])
  end
end
