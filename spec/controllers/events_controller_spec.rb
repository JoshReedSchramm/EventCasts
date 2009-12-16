require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe EventsController do
  def mock_event(stubs={})
    @mock_event ||= mock(Event, stubs)
  end
  def mock_parent_event(stubs={})
    @mock_parent_event ||= mock(Event, stubs)
  end
  def mock_user(stubs={})
    @mock_user ||= mock(User, stubs)
  end
  def mock_event_data(stubs={})
    @mock_event_data ||= mock(EventDatum, stubs)
  end
  
  it "should use EventsController" do
    controller.should be_an_instance_of(EventsController)
  end

  context "When an anonymous user visit a secure section of the site" do
    %w[set_data create add_event_vip].each do |action|
      it "#{action} should redirect the user to the home page" do
        Security.stub!(:is_authenticated?).and_return false        
        get action
        response.should redirect_to(:controller => "home", :action => "index")
      end
    end
  end
  
  describe "when creating a new event" do
    before(:each) do 
      Security.stub!(:is_authenticated?).and_return true       
    end
    
    context "and there is no parent event" do
      it "should render all the events a user owns" do
        Event.should_receive(:create_event).with({}, session[:twitter_name]).and_return(mock_event)
        mock_event.should_receive(:errors).and_return({})
        mock_event.should_receive(:parent).and_return(nil)
    
        post :create, :event=>{}
        response.should redirect_to(:controller=>"user", :action=>"events", :twitter_name=>session[:twitter_name])
      end
    end
    context "and there is a parent event" do
      it "should render all the children of the parent event" do
        Event.should_receive(:create_event).with({}, session[:twitter_name]).and_return(mock_event)
        mock_event.should_receive(:errors).and_return({})
        mock_event.should_receive(:parent).twice.and_return(mock_parent_event)
        mock_parent_event.should_receive(:id).and_return(1)
    
        post :create, :event=>{}
        response.should redirect_to(:controller=>"events", :action=>"event_heirarchy", :id=>1)
      end
    end
    context "and there is a validation error" do
      it "should render an empty response, with a error http status and X-JSON header" do
        Event.should_receive(:create_event).with({}, session[:twitter_name]).and_return(mock_event)
        mock_event.should_receive(:errors).twice.and_return([["error1", "there is an error"]])
        request.should_receive(:xhr?).at_least(:once).and_return(true)        
        
        post :create, :event=>{}
        response.headers.include?("X-JSON").should == true
        response.status.should == "444"
      end
    end
  end
  
  describe "when requesting the events heirarchy" do
    it "should render the heirarchy" do      
      Event.should_receive(:find).with("1").and_return(mock_event)

      get :event_heirarchy, :id=>1
    
      response.should render_template('events/_event_heirarchy')
    end
  end
  
  describe "when adding a event vip" do
   before(:each) do 
      Security.stub!(:is_authenticated?).and_return true       
    end
    context "and the event passed in does not exist" do
      it "should not create the vip" do
        Event.should_receive(:find).with("1").and_return(nil)
       
        post :add_event_vip, :user=>{:event_id=>"1"}
        
        response.should_not render_template("events/_vips")
      end
    end
    context "and the event passed in has a validation error" do
      it "should render an empty response, with a error http status and X-JSON header" do
        Event.should_receive(:find).with("1").and_return(mock_event)
        mock_event.should_receive(:last_updated_by=).with(session[:twitter_name])
        mock_event.should_receive(:add_user_by_twitter_name).with("Fakename")
        mock_event.should_receive(:save!)

        mock_event.should_receive(:errors).twice.and_return([["error1", "there is an error"]])
        request.should_receive(:xhr?).at_least(:once).and_return(true)        
        
        post :add_event_vip, :user=>{:event_id=>"1",:twitter_name=>"Fakename"}
        response.headers.include?("X-JSON").should == true
        response.status.should == "444"
      end
    end
    context "and the event passed in is valid" do
      it "should save the event and render the vip list" do
        Event.should_receive(:find).with("1").and_return(mock_event)
        mock_event.should_receive(:last_updated_by=).with(session[:twitter_name])
        mock_event.should_receive(:add_user_by_twitter_name).with("Fakename")
        mock_event.should_receive(:save!)

        mock_event.should_receive(:errors).and_return({})
        
        post :add_event_vip, :user=>{:event_id=>"1",:twitter_name=>"Fakename"}
        
        response.should render_template("events/_vips")        
      end
    end
  end
  
  describe "when requesting the vip list" do
    it "should render the vip list" do      
      Event.should_receive(:find).with("1").and_return(mock_event)
      mock_event.should_receive(:get_vips).and_return([mock_user])

      get :vips, :event_id=>1
    
      response.should render_template('events/_vips')
    end
  end
  
  describe "when requesting the participants" do
    it "should render the participant list" do      
      Event.should_receive(:find).with("1").and_return(mock_event)

      get :participants, :event_id=>1
    
      response.should render_template('events/_participants')
    end
  end
  
  describe "when requesting a event" do
    context "and the html format is requested" do
      it "should render the event" do      
        User.should_receive(:new).and_return(mock_user)
        Event.should_receive(:find_event_from_heirarchy).with("/test/event").and_return(mock_event)
        
        get :show, :format=>"html", :event_names=>"/test/event"
    
        response.should render_template('events/show')
      end
    end
    context "and the json format is requested" do
      it "should render the event" do      
        User.should_receive(:new).and_return(mock_user)
        Event.should_receive(:find_event_from_heirarchy).with("/test/event").and_return(mock_event)
        mock_event.should_receive(:full_path).and_return("/test/event")
        Event.should_receive(:pull_recent_tweets).and_return("testdata")
        
        get :show, :format=>"json", :event_names=>"/test/event"
    
        response.body.should =="testdata".to_json
      end
    end
    context "and the js format is requested" do
      it "should render the event" do      
        User.should_receive(:new).and_return(mock_user)
        Event.should_receive(:find_event_from_heirarchy).with("/test/event").and_return(mock_event)
        
        get :show, :format=>"js", :event_names=>"/test/event"
    
        response.should render_template('events/_results')
      end
    end
  end 
end
