class EventsController < ApplicationController
  include EventsHelper
  require File.expand_path(File.dirname(__FILE__) + '/../models/lib/twitter_url_generator.rb')
  
  before_filter :authorize, :except=>[:create, :vips, :participants, :show, :recent_tweets]
  
  def create
    if request.post? 
      if !authorized?
        redirect_to :controller => :home, :action => :index
      else
        event = Event.create_event(params, logged_in_user)
        if event.save
          redirect_to :controller=>"events", :action=>"show", :id=>event.id
        end
      end
    end
  end

  def vips
    @event = Event.find(params[:event_id])
    @vips = @event.get_vips
    respond_to do |format|
       format.html { render :partial=>"vips", :layout => false }
     end
  end
  
  def participants
    @event = Event.find(params[:event_id])
    respond_to do |format|
       format.html { render :partial=>"participants", :layout => false }       
     end 
  end
  
  def show
    return render_404 if params.empty?
    
    @event = Event.find_by_id(params[:id])
    return render_404 if @event.nil?        
    
    @twitter_last_message_id = @event.messages.empty? ? "null" :  (@event.messages[0].original_id ||= "null")
    @autoload = @event.messages.empty? ? true : (@event.messages[0].created <= 30.seconds.ago)
        
    url_generator = TwitterURLGenerator.new(@event.search_terms)
    @twitter_search_url = url_generator.generate_url
    respond_to do |format|
      format.html
    end
  end
end