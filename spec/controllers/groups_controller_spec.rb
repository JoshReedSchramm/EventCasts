require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe GroupsController do
  def mock_group(stubs={})
    @mock_group ||= mock(Group, stubs)
  end
  def mock_parent_group(stubs={})
    @mock_parent_group ||= mock(Group, stubs)
  end
  def mock_user(stubs={})
    @mock_user ||= mock(User, stubs)
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
  
  describe "when requesting the groups heirarchy" do
    it "should render the heirarchy" do      
      Group.should_receive(:find).with("1").and_return(mock_group)

      get :group_heirarchy, :id=>1
    
      response.should render_template('groups/_group_heirarchy')
    end
  end
  
  describe "when adding a group vip" do
   before(:each) do 
      Security.stub!(:is_authenticated?).and_return true       
    end
    context "and the group passed in does not exist" do
      it "should not create the vip" do
        Group.should_receive(:find).with("1").and_return(nil)
       
        post :add_group_vip, :user=>{:group_id=>"1"}
        
        response.should_not render_template("groups/_vips")
      end
    end
    context "and the group passed in has a validation error" do
      it "should render an empty response, with a error http status and X-JSON header" do
        Group.should_receive(:find).with("1").and_return(mock_group)
        mock_group.should_receive(:last_updated_by=).with(session[:twitter_name])
        mock_group.should_receive(:add_user_by_twitter_name).with("Fakename")
        mock_group.should_receive(:save!)

        mock_group.should_receive(:errors).twice.and_return([["error1", "there is an error"]])
        request.should_receive(:xhr?).at_least(:once).and_return(true)        
        
        post :add_group_vip, :user=>{:group_id=>"1",:twitter_name=>"Fakename"}
        response.headers.include?("X-JSON").should == true
        response.status.should == "444"
      end
    end
    context "and the group passed in is valid" do
      it "should save the group and render the vip list" do
        Group.should_receive(:find).with("1").and_return(mock_group)
        mock_group.should_receive(:last_updated_by=).with(session[:twitter_name])
        mock_group.should_receive(:add_user_by_twitter_name).with("Fakename")
        mock_group.should_receive(:save!)

        mock_group.should_receive(:errors).and_return({})
        
        post :add_group_vip, :user=>{:group_id=>"1",:twitter_name=>"Fakename"}
        
        response.should render_template("groups/_vips")        
      end
    end
  end
  
  describe "when requesting the vip list" do
    it "should render the vip list" do      
      Group.should_receive(:find).with("1").and_return(mock_group)
      mock_group.should_receive(:get_vips).and_return([mock_user])

      get :vips, :group_id=>1
    
      response.should render_template('groups/_vips')
    end
  end
  
  describe "when requesting the participants" do
    it "should render the participant list" do      
      Group.should_receive(:find).with("1").and_return(mock_group)

      get :participants, :group_id=>1
    
      response.should render_template('groups/_participants')
    end
  end
  
  describe "when requesting a group" do
    context "and the html format is requested" do
      it "should render the group" do      
        User.should_receive(:new).and_return(mock_user)
        Group.should_receive(:find_group_from_heirarchy).with("/test/group").and_return(mock_group)
        
        get :show, :format=>"html", :group_names=>"/test/group"
    
        response.should render_template('groups/show')
      end
    end
    context "and the json format is requested" do
      it "should render the group" do      
        User.should_receive(:new).and_return(mock_user)
        Group.should_receive(:find_group_from_heirarchy).with("/test/group").and_return(mock_group)
        mock_group.should_receive(:full_path).and_return("/test/group")
        Group.should_receive(:pull_recent_tweets).and_return("testdata")
        
        get :show, :format=>"json", :group_names=>"/test/group"
    
        response.body.should =="testdata".to_json
      end
    end
    context "and the js format is requested" do
      it "should render the group" do      
        User.should_receive(:new).and_return(mock_user)
        Group.should_receive(:find_group_from_heirarchy).with("/test/group").and_return(mock_group)
        
        get :show, :format=>"js", :group_names=>"/test/group"
    
        response.should render_template('groups/_results')
      end
    end
  end 
end
