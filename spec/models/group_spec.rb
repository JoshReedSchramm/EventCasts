require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Group do
  before(:each) do
    @valid_attributes = {
       :name=>"my",
       :parent_id=>0
     }  
     @valid = Group.new(@valid_attributes)     
     @valid2 = Group.new(@valid_attributes)     
  end
  
  it "should filter the hash tag" do
    tag_name = "#groupName"
    tag_name = Group.filter_hash(tag_name)
    tag_name.should == "groupName"
  end
  
  describe "When searching by tag name" do
    it "should filter out hash tags" do
      Group.should_receive(:find_group_from_heirarchy).with(["my"], 0, "like")
      Group.search_by_name("#my")
    end
    
    it "should convert a single word to a single item array" do
      "Twoups".split(" ").should == ["Twoups"]
    end
    
    it "should find the tag heirarchically" do
      Group.should_receive(:find).with(:first, :conditions =>["name like ? and parent_id=?", "my", 0]).and_return(@valid)
      Group.find_group_from_heirarchy(["my"], 0, "like")
    end
  end
  
  describe "when verifying uniqueness of a tag" do
    it "should query for other similar tags" do
      @valid.save!
      @valid.parent_id.should == 0
      @valid2.save.should == false
    end
  end
end