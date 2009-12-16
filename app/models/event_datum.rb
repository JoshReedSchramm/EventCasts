class EventDatum < ActiveRecord::Base
  validate :editor_can_edit
  
  belongs_to :event_data_type
  belongs_to :event
  
  def EventDatum.create_or_update(data, user)    
    event_data = EventDatum.find(:first, :conditions=>["event_id=? and event_data_type_id=?", data[:event_id], data[:event_data_type_id]])
    if event_data.nil?
      event_data = EventDatum.new(data)
      event_data.last_updated_by = user              
    else
      event_data.last_updated_by = user                    
      event_data.update_attributes(data)
    end
    event_data
  end
  
  private
  
  def editor_can_edit
    user = User.find_by_twitter_name(self.last_updated_by)
    Security.can_edit_event?(user, self.event)    
  end
end
