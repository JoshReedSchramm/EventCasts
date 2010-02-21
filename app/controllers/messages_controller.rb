class MessagesController < ApplicationController
  def persist
    messages = Message.from_json(params[:messages])

    messages.each do |message| 
      message.save
    end

    respond_to do |format|
       format.js { render :partial=>"persist", :layout => false }
     end
  end
end