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
  

end
