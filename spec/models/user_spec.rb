require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do
    @valid_attributes = {
      :ec_username => "TwoupsInfo",
      :password => "password"
    }
    @valid_user = User.new(@valid_attributes)
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end
  
  context "when creating a new user" do
    context "and the username is blank" do
      before(:each) do
        @invalid_user = User.new({:ec_username=>"", :password=>"password"})
      end      
      it "should return a validation error" do
        @invalid_user.save.should == false
        @invalid_user.errors.count.should == 1
        @invalid_user.errors["username"].nil?.should == false
      end
    end 
    context "and the password is blank" do
      before(:each) do
        @invalid_user = User.new({:ec_username=>"username", :password=>""})
      end      
      it "should return a validation error" do
        @invalid_user.save.should == false
        @invalid_user.errors.count.should == 1
        @invalid_user.errors["password"].nil?.should == false
      end      
    end
    context "and the username is repeated" do
      it "should return a validation error" do
        user_one = User.new(@valid_attributes)
        user_two = User.new(@valid_attributes)        
        user_one.save.should == true                  
        user_two.save.should == false          
        user_two.errors.count.should == 1
        user_two.errors["username"].nil?.should == false
      end
    end
    context "and valid attributes are provided" do  
      it "should save correctly" do
        @valid_user.save.should == true
      end
      it "should have a hashed password" do
        @valid_user.save
        user = User.find(@valid_user.id)
        user.hashed_password.nil?.should == false
      end 
    end
  end
    
end
