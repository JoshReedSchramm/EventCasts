require 'json'

class Message < ActiveRecord::Base
  belongs_to :event
  
  def Message.from_json(messages)
    result = []
    JSON.load(messages).each do |message|
      result << Message.new(message)
    end    
    result
  end
end
