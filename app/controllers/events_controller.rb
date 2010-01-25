class EventsController < ApplicationController
  include EventsHelper
  require File.expand_path(File.dirname(__FILE__) + '/../models/lib/twitter_url_generator.rb')
  
  before_filter :authorize, :except=>[:create, :vips, :participants, :show, :recent_tweets]
  
  def create
    if request.post?
      @event = Event.new(params[:event])
      params[:search_terms].each do |term|
        @event.search_terms << SearchTerm.new({:term=>term})
      end unless params[:search_terms].nil?
      if @event.save
        redirect_to :controller=>"events", :action=>"show", :id=>@event.id
      end
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
    @event = Event.find_by_id(params[:id])
    url_generator = TwitterURLGenerator.new(@event.search_terms)
    @twitter_search_url = url_generator.generate_url
    respond_to do |format|
      format.html
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