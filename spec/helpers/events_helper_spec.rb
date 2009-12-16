require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EventsHelper do
  def mock_event(stubs={})
    @mock_event ||= mock(Event, stubs)
  end
  
  context "when passed in a valid event path" do    
    it "should get event for display" do
      Event.should_receive(:find_event_from_heirarchy).with(["test", "event"]).and_return(mock_event)
    
      (helper.send :get_event_for_display, ["test", "event"]).should == mock_event
    end
  end
  context "when passed an unknown event" do    
    it "should create a event for display" do
      Event.should_receive(:find_event_from_heirarchy).with(["test", "event"]).and_return(nil)
      Event.should_receive(:new).and_return(mock_event)
      mock_event.should_receive(:name=).with("test")
      mock_event.should_receive(:full_path=).with("test/event")
    
      (helper.send :get_event_for_display, ["test", "event"]).should == mock_event
    end
  end
end
