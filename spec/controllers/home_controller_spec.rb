require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HomeController do
  describe "when visiting the homepage" do
    context "and are an anonymous user" do
      it "should render the index template" do
        get :index
        response.should render_template("index")
      end
    end
  end
end
