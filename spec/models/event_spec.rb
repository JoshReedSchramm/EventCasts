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
end