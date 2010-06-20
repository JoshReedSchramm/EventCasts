require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserController do
  def mock_oauth(stubs={})
    @mock_oauth ||= mock(Twitter::OAuth, stubs)
  end
  def mock_user(stubs={})
    @mock_user ||= mock(User, stubs)
  end
  
  describe "when creating a new user" do
    context "and it is not an ajax request" do
      context "and the user is valid" do
        it "should save the user and redirect to user home" do
          User.should_receive(:new).with({"username"=>"User", "password"=>"password", "email"=>"text.email@email.com"}).and_return(mock_user)
          mock_user.should_receive(:save).and_return(true)
          post :register, :user=>{:username=>"User", :password=>"password", :email=>"text.email@email.com"}
          response.should redirect_to(:controller=>"user", :action=>"home")        
          session[:user].should == mock_user
        end
      end
      context "and there is a validation error" do
        it "should return error messages and render the create view" do
          User.should_receive(:new).with({"username"=>"User", "password"=>"password", "email"=>"text.email@email.com"}).and_return(mock_user)
          mock_user.should_receive(:save).and_return(false)
          post :register, :user=>{:username=>"User", :password=>"password", :email=>"text.email@email.com"}          
        end
      end
    end
    context "and it is an ajax request" do
      context "and the user is valid" do
        it "should save the user and return a 'true' response" do
          User.should_receive(:new).with({"username"=>"User", "password"=>"password", "email"=>"text.email@email.com"}).and_return(mock_user)
          mock_user.should_receive(:save).and_return(true)
          xhr :post, :register, :user=>{:username=>"User", :password=>"password", :email=>"text.email@email.com"}
          response.body.should == "true"
          session[:user].should == mock_user          
        end
      end
      context "and there is a validation error" do 
        it "should render an empty response, with a error http status and X-JSON header" do
          User.should_receive(:new).with({"username"=>"User", "password"=>"password", "email"=>"text.email@email.com"}).and_return(mock_user)
          mock_user.should_receive(:save).and_return(false)
          mock_user.should_receive(:errors).at_least(:once).and_return({:username=>"This is a test validation message"})
          xhr :post, :register, :user=>{:username=>"User", :password=>"password", :email=>"text.email@email.com"}
          response.status.should == 444
          response.headers['X-JSON'].should=={:username=>"This is a test validation message"}.to_json
        end
      end
    end
  end
  describe "when logging in" do
    context "and the username and password is valid" do
      it "should return the user account" do
        User.should_receive(:authenticate).with("username", "password").and_return(mock_user)
        post :login, :user=>{:ec_username=>"username", :password=>"password"}   
        session[:user].should==mock_user   
        response.should redirect_to(:controller=>"user", :action=>"home")        
      end
    end
    context "and the username or password is invalid" do
      it "should display a flash message to the user" do
        User.should_receive(:authenticate).with("username", "").and_return(nil)
        post :login, :user=>{:ec_username=>"username", :password=>""}      
        flash[:notice].should include("Unable to find a user with that username and password.")
      end
    end
    context "and the request is an ajax login request" do
      context "and the username or password are invalid" do
        it "should have an error collection in the response and a 444 status code" do
          User.should_receive(:authenticate).with("username", "").and_return(nil)
          xhr :post, :login, :user=>{:ec_username=>"username", :password=>""}    
          response.status.should == 444
          response.headers['X-JSON'].should=="[[\"username\",\"The username or password entered did not match a valid user\"]]";
        end
      end
    end
  end
  
  describe "when viewing the user home page" do
    context "and the user is logged in" do
      it "should render the template" do
        session[:user] = mock_user
        get :home
        response.should render_template("user/home")        
        response.status.should == 200        
      end
    end
    context "and the user is logged out" do
      it "should set the flash message and tender the login page" do
        get :home
        response.should render_template(:controller=>"user", :action=>"login")        
        flash[:notice].should include("You must be logged in to view that page.")        
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
  describe "when logging out" do
    it "should clear session" do
      session[:user]=mock_user
      get :logout
      session[:user].should == nil
    end
    it "should redirect to home page" do
      session[:user]=mock_user
      get :logout
      response.should redirect_to("/")
    end
  end
  
  describe "when logging in through twitter" do
    it "should redirect to twitter" do      
      mock_request_token = mock(Twitter::Request, {:token=>"testtoken", :secret=>"testsecret", :authorize_url=>"http://localhost:3000"})
      Twitter::OAuth.should_receive(:new).and_return(mock_oauth({:request_token=>mock_request_token}))    
      mock_oauth.should_receive(:set_callback_url)
      get :start_twitter
      response.should redirect_to("http://localhost:3000")    
    end
  end
  
  describe "when returning from a twitter login" do
    before(:each) do
      @mock_token = mock(Twitter::Response, {:token=>"testtoken", :secret=>"testsecret"}) 
      Twitter::OAuth.should_receive(:new).and_return(mock_oauth({:access_token=>@mock_token}))          
      mock_oauth.should_receive(:authorize_from_request)      
      @mock_profile = mock(Twitter::Request, {:screen_name=>"Eventcasts"})
      Twitter::Base.should_receive(:new).with(mock_oauth).and_return(mock(Twitter::Base, {:verify_credentials=>@mock_profile}))      
    end    
    
    it "should add oauth info to session" do      
      post :finalize_twitter, :oauth_verifier=>"TEST"
      
      session[:atoken].should == "testtoken"
      session[:asecret].should == "testsecret"
    end
    
    it "adds the user to session" do    
      User.should_receive(:get_from_twitter).with(@mock_profile).and_return(mock_user)
      post :finalize_twitter, :oauth_verifier=>"TEST"
      
      session[:user].should == mock_user
    end
    
    it "redirects to user home" do            
      post :finalize_twitter, :oauth_verifier=>"TEST"
      
      response.should redirect_to(:controller=>"user", :action=>"home")
    end
  end
  
  describe "when viewing a users events" do
    it "should render the event list template" do
      session[:user] = mock_user      
      get :events
      response.should render_template("user/events")
      response.status.should == 200
    end
  end
end
