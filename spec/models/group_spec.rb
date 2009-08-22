require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Group do
  before(:each) do
    @valid_attributes = {
      :name => "MY_Tag"      
    }    
  end
  
  it "should filter the hash tag" do
    tag_name = "#groupName"
    tag_name = Group.filter_hash(tag_name)
    tag_name.should == "groupName"
  end
    

  it "should create a new instance given valid attributes" do
    Group.create!(@valid_attributes)
  end
end
