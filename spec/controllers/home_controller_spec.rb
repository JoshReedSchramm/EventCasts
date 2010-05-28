require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HomeController do
  def mock_user(stubs={})
    @mock_user ||= mock(User, stubs)
  end
  def mock_search_result(stubs={})
    @mock_search_result ||= mock(SearchResult, stubs)
  end  
  describe "when visiting the homepage" do
    context "and are an anonymous user" do
      it "should render the index template" do
        get :index
        response.should render_template("index")
      end
    end
    context "and are a logged in user" do
      it "should render set the user and render the index template" do
        session[:twitter_name] = "TestUser"
        User.should_receive(:find_by_twitter_name).with("TestUser").and_return(mock_user)
        get :index
        assigns(:user).should equal(mock_user)
        response.should render_template("index")
      end
    end
    context "and are posting a search query" do
      it "should set the search_term and render the index template" do      
        post :index, :search=>{:query=>"MyQuery"}
        assigns(:auto_search).should == true
        assigns(:search_term).should == "MyQuery"
        response.should render_template("index")
      end
    end
  end
  describe "when searching" do
    it "should render the search results" do
      Search.should_receive(:search).with("MyQuery").and_return(mock_search_result)
      post :search, :search=>"MyQuery"
      assigns(:results).should equal(mock_search_result)
      response.should render_template("home/search")      
    end
  end
  describe "when viewing the about us page" do
    context "and the user is logged in" do
      it "should get the user and render the about us page" do
        session[:twitter_name] = "TestUser"
        User.should_receive(:find_by_twitter_name).with("TestUser").and_return(mock_user)
        get :about_us
        assigns(:user).should equal(mock_user)
        response.should render_template("about_us")
      end
    end
  end
end
