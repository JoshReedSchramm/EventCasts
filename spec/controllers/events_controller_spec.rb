require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe EventsController do
  def mock_event(stubs={})
    @mock_event ||= mock(Event, stubs)
  end
  def mock_search_term(stubs={})
    @mock_event ||= mock(SearchTerm, stubs)
  end
  def mock_user(stubs={})
    @mock_user ||= mock(User, stubs)
  end
  def mock_url_generator(stubs={})
    @mock_url_generator ||= mock(TwitterURLGenerator, stubs)
  end
  def mock_message(stubs={})
    @mock_message ||= mock(Message, stubs)
  end
  
  specify { controller.should be_an_instance_of(EventsController) }
  
  # context "when requesting an event" do
  #   context "and the html format is request" do
  #     before { }
        
  describe "when requesting a event" do
    context "and the html format is requested" do
      it "should render the event" do         
        expected_messages = [mock_message]
        
        Event.stub(:find_by_id).and_return(mock_event({:search_terms=>[], :messages=>[mock_message]}))     
        
        mock_message.should_receive(:original_id).and_return(1)
        mock_message.should_receive(:created).and_return(Time.now)        
        
        TwitterURLGenerator.should_receive(:new).and_return(mock_url_generator)  
        fake_url = "fakeurl"      
        mock_url_generator.should_receive(:generate_url).and_return(fake_url)
        
        get :show, :format=>"html", :id=>1
    
        assigns(:twitter_search_url).should == fake_url
        assigns(:twitter_last_message_id).should == 1        
        response.should render_template('events/show')
      end
      context "and there is a previous message" do
        before(:each) do
          Event.should_receive(:find_by_id).with(1).and_return(mock_event)
          mock_event.should_receive(:search_terms).and_return([])

          mock_event.should_receive(:messages).at_least(2).times.and_return([mock_message])
          mock_message.should_receive(:original_id).and_return(1)
        end
        it "should set set the last message id" do          
          mock_message.should_receive(:created).and_return(45.seconds.ago)                              
          get :show, :format=>"html", :id=>1                                
          assigns(:twitter_last_message_id).should == 1
        end        
        context "and last updated message is older than 30 seconds" do
          before(:each) do
            mock_message.should_receive(:created).and_return(45.seconds.ago)                    
            get :show, :format=>"html", :id=>1                      
          end
          it "should set autoload true" do                      
            assigns(:autoload).should == true
          end
        end
        context "and last updated message is younger than 30 seconds" do
          before(:each) do
            mock_message.should_receive(:created).and_return(15.seconds.ago)                    
            get :show, :format=>"html", :id=>1                      
          end
          it "should set autoload false" do                      
            assigns(:autoload).should == false
          end
        end
      end
      context "and there is no previous message" do
        before(:each) do
          Event.should_receive(:find_by_id).with(1).and_return(mock_event)
          mock_event.should_receive(:search_terms).and_return([])
          mock_event.should_receive(:messages).at_least(2).times.and_return([])
          get :show, :format=>"html", :id=>1                                          
        end
        it "should set set the last message id to null" do          
          assigns(:twitter_last_message_id).should == "null"
        end        
        it "should set autoload true" do                      
          assigns(:autoload).should == true
        end
      end
    end
    context "and no event name is passed" do
      it "should render a 404" do
        get :show, :format=>"html"
        response.response_code.should == 404
      end
    end
    context "and the event is not found" do
      it "should render a 404" do
        Event.should_receive(:find_by_id).with(1).and_return(nil)
        
        get :show, :format=>"html", :id=>1
        
        response.response_code.should == 404
      end
    end
  end
  describe "when saving an event" do
    context "and the user is not logged in" do
      it "should redirect to the login page" do        
        params = { :event => {"name"=>"Test Event", "description"=>"My Test Event"}, :search_terms=>["The Phrase", "Phrase Two"]}
        session[:user] = nil
        
        post :create, params
        
        response.should redirect_to(:controller => "user", :action => "login") 
      end
    end
    context "and the passed in data is valid" do
      it "should save the event and redirect to the show event page" do
        params = { :event => {"name"=>"Test Event", "description"=>"My Test Event"}, :search_terms=>["The Phrase", "Phrase Two"]}
        session[:user] = mock_user
        

        Event.should_receive(:create_event).and_return(mock_event)
        
        mock_event.should_receive(:save).and_return true
        mock_event.should_receive(:id).and_return(1)
        
        post :create, params
        response.should redirect_to(:controller => "events", :action => "show", :id=>1) 
      end
    end
    context "and the passed in data is invalid" do
      it "should render the create page with validation errors" do
        params = { :event => {"name"=>"Test Event", "description"=>"My Test Event"}, :search_terms=>["The Phrase", "Phrase Two"]}
        session[:user] = mock_user

        Event.should_receive(:create_event).and_return(mock_event)       

        mock_event.should_receive(:save).and_return false
        post :create, params
        response.should render_template('events/create') 
      end
    end
  end
end
