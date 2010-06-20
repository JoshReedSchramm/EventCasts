require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Event do
  
  def mock_event(stubs={})
     @mock_event ||= mock(Event, stubs)
   end
   def mock_search_term(stubs={})
     @mock_event ||= mock(SearchTerm, stubs)
   end
   def mock_user(stubs={})
     @mock_user ||= mock(User, stubs)
   end
   
  before(:each) do
    @valid_attributes = {
       :name=>"my"
    }  
     @valid = Event.new(@valid_attributes)     
     @valid2 = Event.new(@valid_attributes)     
  end
  
  context "when creating an event" do
    it "should return a new event with the data elements set" do
      params = { :event => {"name"=>"Test Event", "description"=>"My Test Event"}, :search_terms=>["The Phrase", "Phrase Two"]}
      
      mock_logged_in_user_id
      mock_search_term_creation                      
      
      result = Event.create_event(params, mock_user)      
      result.name.should == "Test Event"
      result.description.should == "My Test Event"      
      result.search_terms.length.should == 2
    end
    
    
    def mock_logged_in_user_id
      mock_user.should_receive(:id).and_return(1)
    end

    def mock_search_term_creation
      st1 = SearchTerm.new({:term=>"The Phrase"})
      st2 = SearchTerm.new({:term=>"Phrase Two"})

      SearchTerm.should_receive(:new).with({:term=>"The Phrase"}).and_return(st1)
      SearchTerm.should_receive(:new).with({:term=>"Phrase Two"}).and_return(st2)
    end
  end  

  context "when saving an event" do
    it "should validate that at least one search term is provided" do
      event = Event.new()
      event.name = "My Name"
      event.description = "Event Description"
      event.save.should == false
      # event.errors.length.should == 1
    end
    it "should save if all required fields are provided and valid" do
      event = Event.new()
      event.name = "My Name"
      event.description = "Event Description"
      st1 = SearchTerm.new()
      st1.term = "the term"
      event.search_terms << st1
      event.save.should == true
      st1.id.should_not == nil
    end
   end
   
   it "should have humanized model names" do
     Event.human_attribute_name(:name).should == "Event Name"
   end   
end
