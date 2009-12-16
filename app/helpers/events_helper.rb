module EventsHelper
  
  private 
  
  def get_event_for_display(event_names)
    event = Event.find_event_from_heirarchy(event_names)
    if event.nil?
      event = Event.new()
      unknown_path = "";
      if !event_names.nil?
        unknown_path = event_names.join('/')
        event.name = event_names[0]
      end
      event.full_path = unknown_path
    end
    event
  end
end
