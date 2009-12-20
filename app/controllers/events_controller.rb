class EventsController < ApplicationController
  include EventsHelper
  
  before_filter :authorize, :except=>[:create, :vips, :participants, :show, :recent_tweets]
  
  def create
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
    @event = Event.find_by_id(params[:id])
    respond_to do |format|
      format.html
      format.json { render :json =>  Event.pull_recent_tweets(@event.name,params[:num],params[:since_id]).to_json }
      format.js { render :partial=> "results" }
    end
  end
  
  def set_data
    event = Event.create_or_update(params[:event], session[:twitter_name])   
    event.save
    respond_to do |format|
      format.json  { render :json => event.to_json }
    end unless handle_ajax_validation_errors(event)    
  end
end