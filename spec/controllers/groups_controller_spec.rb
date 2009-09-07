require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe GroupsController do
  def mock_group(stubs={})
    @mock_group ||= mock(Group, stubs)
  end
  def mock_parent_group(stubs={})
    @mock_parent_group ||= mock(Group, stubs)
  end
  def mock_group_data(stubs={})
    @mock_group_data ||= mock(GroupDatum, stubs)
  end
  
  it "should use GroupsController" do
    controller.should be_an_instance_of(GroupsController)
  end

  context "When an anonymous user visit a secure section of the site" do
    %w[set_data create add_group_vip].each do |action|
      it "#{action} should redirect the user to the home page" do
        Security.stub!(:is_authenticated?).and_return false        
        get action
        response.should redirect_to(:controller => "home", :action => "index")
      end
    end
  end
  
  describe "when creating a new group" do
    before(:each) do 
      Security.stub!(:is_authenticated?).and_return true       
    end
    
    context "and there is no parent group" do
      it "should render all the groups a user owns" do
        Group.should_receive(:create_group).with({}, session[:twitter_name]).and_return(mock_group)
        mock_group.should_receive(:errors).and_return({})
        mock_group.should_receive(:parent).and_return(nil)
    
        post :create, :group=>{}
        response.should redirect_to(:controller=>"user", :action=>"groups", :twitter_name=>session[:twitter_name])
      end
    end
    context "and there is a parent group" do
      it "should render all the children of the parent group" do
        Group.should_receive(:create_group).with({}, session[:twitter_name]).and_return(mock_group)
        mock_group.should_receive(:errors).and_return({})
        mock_group.should_receive(:parent).twice.and_return(mock_parent_group)
        mock_parent_group.should_receive(:id).and_return(1)
    
        post :create, :group=>{}
        response.should redirect_to(:controller=>"groups", :action=>"group_heirarchy", :id=>1)
      end
    end
    context "and there is a validation error" do
      it "should render an empty response, with a error http status and X-JSON header" do
        Group.should_receive(:create_group).with({}, session[:twitter_name]).and_return(mock_group)
        mock_group.should_receive(:errors).twice.and_return([["error1", "there is an error"]])
        request.should_receive(:xhr?).at_least(:once).and_return(true)        
        
        post :create, :group=>{}
        response.headers.include?("X-JSON").should == true
        response.status.should == "444"
      end
    end
  end
end
