require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Event do
  before(:each) do
    @valid_attributes = {
       :name=>"my"
    }  
     @valid = Event.new(@valid_attributes)     
     @valid2 = Event.new(@valid_attributes)     
  end
  
  it "should filter the hash tag" do
    tag_name = "#eventName"
    tag_name = Event.filter_hash(tag_name)
    tag_name.should == "eventName"
  end


  context "when saving an event" do
    it "should validate that at least one search term is provided" do
      event = Event.new()
      event.name = "My Name"
      event.description = "Event Description"
      event.save.should == false
      event.errors.length.should == 1
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
end