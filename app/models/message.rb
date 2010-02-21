require 'json'

class Message < ActiveRecord::Base
  belongs_to :event
  
  def Message.from_json(messages)
    result = []
    return result if messages.nil?
    messages.each do |message|
      result << Message.new(message)
    end    
    result
  end
  
  def Message.find_last_message_id_for_event(event_id)
    result = Message.find_by_event_id(event_id, :order=>"created desc", :limit=>1)
    return result.nil? ? nil : result.original_id
  end
end
