require 'json'

class MessagesController < ApplicationController
  def persist
    @js = params[:_json]
    messages = Message.from_json(params[:_json])
    @m = messages

    messages.each do |message| 
      message.save
    end

    respond_to do |format|
       format.html { render :partial=>"persist", :layout => false }
     end
  end
end