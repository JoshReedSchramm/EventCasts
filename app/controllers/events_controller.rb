class EventsController < ApplicationController
  include EventsHelper
  
  before_filter :authorize, :except=>[:vips, :participants, :show, :recent_tweets, :event_heirarchy]
  
  def create
      @event = Event.create_event(params[:event], session[:twitter_name])    
      return if handle_ajax_validation_errors(@event)
      if (@event.parent.nil?)
        redirect_to :controller=>"user", :action=>"events", :twitter_name=>session[:twitter_name]
      else
        redirect_to :controller=>"events", :action=>"event_heirarchy", :id=>@event.parent.id
      end
    end

    def event_heirarchy
      @event = Event.find(params[:id])
      respond_to do |format|
        format.html  { render :partial=>'event_heirarchy', :layout=>false }
      end
    end
  
  def add_event_vip
    user = params[:user]
    @event = Event.find(user[:event_id])
    return if @event.nil?
    @event.last_updated_by = session[:twitter_name]

    @event.add_user_by_twitter_name(user[:twitter_name])
    @event.save!
    
    respond_to do |format|
      format.html { render :partial=>"vips", :layout => false }       
    end unless handle_ajax_validation_errors(@event)
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
    @vip_user = User.new()
    @event = get_event_for_display(params[:event_names])
    respond_to do |format|
      format.html
      format.json { render :json =>  Event.pull_recent_tweets(@event.full_path,params[:num],params[:since_id]).to_json }
      format.js { render :partial=> "results" }
    end
  end
end