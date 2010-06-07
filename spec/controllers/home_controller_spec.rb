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
      it "should render the about us page" do
        get :about_us
        response.should render_template("about_us")
      end
    end
  end
end
