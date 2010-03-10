require 'json'

class MessagesController < ApplicationController
  def persist
    @messages = Message.from_json(params[:_json])
    @messages.each do |message| 
      message.save
    end

    respond_to do |format|
       format.html { render :partial=>"persist", :layout => false }
     end
  end
end