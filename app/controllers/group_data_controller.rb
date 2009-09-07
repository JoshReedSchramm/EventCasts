class GroupDataController < ApplicationController
  def set_data 
    group_data = GroupDatum.create_or_update(params[:group_datum], session[:twitter_name])   
    group_data.save
    respond_to do |format|
      format.json  { render :json => group_data.to_json }
    end unless handle_ajax_validation_errors(group_data)    
  end
end
