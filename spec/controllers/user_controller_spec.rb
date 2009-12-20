require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserController do
  def mock_user(stubs={})
    @mock_user ||= mock(User, stubs)
  end
  
  describe "when creating a new user" do
    it "should save the user" do
      User.should_receive(:new).with({"username"=>"User", "password"=>"password"}).and_return(mock_user)
      mock_user.should_receive(:save).and_return(true)
      post :register, :user=>{:username=>"User", :password=>"password"}
    end
      
    context "and there is a validation error" do
      it "should render an empty response, with a error http status and X-JSON header" do
        User.should_receive(:new).with({"username"=>"User", "password"=>""}).and_return(mock_user)
        mock_user.should_receive(:save).and_return(false)
        post :register, :user=>{:username=>"User", :password=>""}
      end
    end
  end  
  
  describe "when logging in" do
    context "and the username and password is valid" do
      it "should return the user account" do
        User.should_receive(:authenticate).with("username", "password").and_return(mock_user)
        mock_user.should_receive(:id).and_return(1)
        post :login, :user=>{:username=>"username", :password=>"password"}   
        session[:id].should==1   
        response.should redirect_to(:controller=>"user", :action=>"home")        
      end
    end
    context "and the username or password is invalid" do
      it "should display a flash message to the user" do
        User.should_receive(:authenticate).with("username", "").and_return(nil)
        post :login, :user=>{:username=>"username", :password=>""}      
        flash[:notice].should have_text("Unable to find a user with that username and password.")
      end
    end
  end
  
  describe "when viewing the user home page" do
    context "and the user is logged in" do
      it "should retrieve the user and render the template" do
        session[:id] = 1
        User.should_receive(:find_by_id).and_return(mock_user)
        get :home
        response.should render_template("user/home")        
      end
    end
    context "and the user is logged out" do
      it "should set the flash message and redirect the user to the homepage" do
        session[:id] = nil
        get :home
        response.should redirect_to(:controller=>"home", :action=>"index")        
        flash[:notice].should have_text("You must be logged in to view that page.")        
      end
    end
  end
end
