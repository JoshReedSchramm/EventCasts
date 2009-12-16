class AddDefaultEventData < ActiveRecord::Migration
  def self.up
    url = EventDataType.find_by_name('url')
    event = Event.find(1)
    
    ed = EventDatum.new()
    ed.event_data_type = url
    ed.event = event
    ed.description = "http://www.google.com"
    puts ed.nil?    
  end

  def self.down
    EventDatum.delete_all
  end
end
