class EventDataType < ActiveRecord::Base
  has_many :event_data
  
  def EventDataType.description
    EventDataType.find_by_name("description")
  end
  
  def EventDataType.title
    EventDataType.find_by_name("title")
  end  
end
