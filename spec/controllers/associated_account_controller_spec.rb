require 'spec_helper'

describe AssociatedAccountController do
  def mock_user(stubs={})
    @mock_user ||= mock(User, stubs)
  end
  def mock_oauth(stubs={})
    @mock_oauth ||= mock(Twitter::OAuth, stubs)
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
    end
    context "and the credentials are valid" do
      before(:each) do
        @mock_profile = mock(Twitter::Request, {:screen_name=>"Eventcasts"})
        Twitter::Base.should_receive(:new).with(mock_oauth).and_return(mock(Twitter::Base, {:verify_credentials=>@mock_profile}))      
      end    

      it "should add oauth info to session" do      
        post :finalize_twitter, :oauth_verifier=>"TEST"

        session[:atoken].should == "testtoken"
        session[:asecret].should == "testsecret"
      end

      it "adds the user to session if not already logged in" do    
        User.should_receive(:get_from_twitter).with(@mock_profile).and_return(mock_user)
        post :finalize_twitter, :oauth_verifier=>"TEST"

        session[:user].should == mock_user
      end

      it "associated the twitter account to the current user if already logged in" do    
        session[:user] = mock_user                        

        mock_user.should_receive(:associate_account).with("Eventcasts", 1)
        mock_user.should_receive(:save).and_return(true)

        post :finalize_twitter, :oauth_verifier=>"TEST"      
      end

      it "redirects to user home" do            
        post :finalize_twitter, :oauth_verifier=>"TEST"

        response.should redirect_to(:controller=>"user", :action=>"home")
      end
    end
    context "and the credentials are invalid" do
      before(:each) do
        @mock_profile = mock(Twitter::Request, {:screen_name=>"Eventcasts"})
        @mock_twitter_base = mock(Twitter::Base)
        Twitter::Base.should_receive(:new).with(mock_oauth).and_return(@mock_twitter_base)
        @mock_twitter_base.should_receive(:verify_credentials).and_raise(Twitter::Unauthorized.new(nil))              
      end    

      it "set the flash notification" do     
        post :finalize_twitter, :oauth_verifier=>"TEST"
        flash[:error].should  == 'You must be signed into twitter to use this feature. Please sign in again.'      
      end

      it "redirect to the login page" do    
        post :finalize_twitter, :oauth_verifier=>"TEST"
        response.should redirect_to(:controller=>"user", :action=>"login")                     
      end
    end
  end

  describe "when associating a new account" do

    before(:each) do
      session[:user] = mock_user({:id=>1})

      @twitter_account = mock_model(AssociatedAccountType, {:name=>"twitter", :abbreviation=>"TW", :id=>1})
      @ec_account = mock_model(AssociatedAccountType, {:name=>"eventcasts", :abbreviation=>"EC", :id=>0})      

      AssociatedAccountType.should_receive(:all).and_return([@twitter_account])
      User.stub(:find).with(1).and_return(mock_user)      
    end

    context "and the user does not have a twitter account" do 
      before(:each) do 
        mock_user.should_receive(:ec_username).and_return("test")        
      end     
      it "should display twitter as an option" do
        
        mock_user.should_receive(:has_account_type).with(1).and_return(false)        
        get :add
        assigns[:account_types_to_show].should == [@twitter_account]
      end
    end

    context "and the user does not have an eventcasts account" do      
      before(:each) do        
        mock_user.should_receive(:ec_username).and_return(nil)        
        AssociatedAccountType.should_receive(:new).and_return(@ec_account)
      end      

      it "should display eventcasts as an option" do        
        mock_user.should_receive(:has_account_type).with(1).and_return(true)        
        get :add
        assigns[:account_types_to_show].should == [@ec_account]
      end
    end
  end

  describe "When adding an eventcasts account" do    
    before(:each) do
      session[:user] = mock_user({:id=>1, :ec_username=>"Eventcasts"})
      User.stub(:find).with(1).and_return(mock_user)            
    end
    
    context "and the account info submitted is valid" do        
      it "should create the account and redirect to the user account page" do
        params = { :user => {"ec_username"=>"test", "password"=>"password"}}        
        User.should_receive(:update).with(1, params[:user]).and_return(mock_user)
        mock_user.should_receive(:errors).and_return(nil)
        
        post :associate_eventcasts, params      
        
        assigns[:updated_user].should == mock_user                
        response.should redirect_to(:controller=>"user", :action=>"accounts")
      end
    end
    context "and the account info submitted is invalid" do
      it "should set the flash error and redirect back to the add page" do
        params = { :user => {"ec_username"=>"test", "password"=>"password"}}
        User.should_receive(:update).with(1, params[:user]).and_return(mock_user)
        mock_user.should_receive(:errors).and_return({:ec_username=>"Error"})        

        post :associate_eventcasts, params      
        
        assigns[:updated_user].should == mock_user
        response.should render_template(:action=>"add")          
      end
    end    
  end
end