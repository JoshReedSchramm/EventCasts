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
        post :login, :user=>{:username=>"username", :password=>"password"}   
        session[:user].should==mock_user   
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
    context "and the request is an ajax login request" do
      context "and the username or password are invalid" do
        it "should have an error collection in the response and a 444 status code" do
          User.should_receive(:authenticate).with("username", "").and_return(nil)
          request.should_receive(:xhr?).twice().and_return(true)          
          post :login, :user=>{:username=>"username", :password=>""}    
          response.status.should == "444"
          response.headers['X-JSON'].should=={:username=>"The username or password entered did not match a valid user."}.to_json
        end
      end
      context "and the username or password are valid" do
        it "should not redirect" do
          User.should_receive(:authenticate).with("username", "password").and_return(mock_user)
          request.should_receive(:xhr?).twice().and_return(true)                    
          post :login, :user=>{:username=>"username", :password=>"password"}   
          session[:user].should==mock_user   
          response.should_not redirect_to(:controller=>"user", :action=>"home")        
        end
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
  
  describe "when verifying if the user is logged in" do
    context "and the user is logged in" do
      it "should return the phrase 'true' and no further markup" do
        session[:user]=mock_user
        get :verify_login
        response.body.should == "true"
      end
    end
    context "and the user is not logged in" do
      it "should render the login element" do
        session[:user]=nil
        get :verify_login        
        response.should render_template("user/_login")                
      end
    end
  end
end
