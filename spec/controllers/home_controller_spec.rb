require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HomeController do
  def mock_user(stubs={})
    @mock_user ||= mock(User, stubs)
  end
  context "when visiting the homepage as an anonymous user" do
    it "should render the index template" do
      get :index
      response.should render_template("index")
    end
  end
  context "when visiting the homepage as a logged in user" do
    it "should render set the user and render the index template" do
      session[:twitter_name] = "TestUser"
      User.should_receive(:find_by_twitter_name).with("TestUser").and_return(mock_user)
      get :index
      assigns[:user].should equal(mock_user)
      response.should render_template("index")
    end
  end
  context "when posting a search query to the home page" do
    it "should set the search_term and render the index template" do      
      post :index, :search=>{:query=>"MyQuery"}
      assigns[:auto_search].should == true
      assigns[:search_term].should == "MyQuery"
      response.should render_template("index")
    end
  end
end
