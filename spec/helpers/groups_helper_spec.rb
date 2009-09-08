require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GroupsHelper do
  def mock_group(stubs={})
    @mock_group ||= mock(Group, stubs)
  end
  
  context "when passed in a valid group path" do    
    it "should get group for display" do
      Group.should_receive(:find_group_from_heirarchy).with(["test", "group"]).and_return(mock_group)
    
      (helper.send :get_group_for_display, ["test", "group"]).should == mock_group
    end
  end
  context "when passed an unknown group" do    
    it "should create a group for display" do
      Group.should_receive(:find_group_from_heirarchy).with(["test", "group"]).and_return(nil)
      Group.should_receive(:new).and_return(mock_group)
      mock_group.should_receive(:name=).with("test")
      mock_group.should_receive(:full_path=).with("test/group")
    
      (helper.send :get_group_for_display, ["test", "group"]).should == mock_group
    end
  end
end
