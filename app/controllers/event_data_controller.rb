class EventDataController < ApplicationController
  def set_data 
    event_data = EventDatum.create_or_update(params[:event_datum], session[:twitter_name])   
    event_data.save
    respond_to do |format|
      format.json  { render :json => event_data.to_json }
    end unless handle_ajax_validation_errors(event_data)    
  end
end
